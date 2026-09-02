#!/usr/bin/env bash
# Bootstrap a new macOS or Linux machine from this repo.
#
#   git clone git@github.com:rafaelmian1/.dotfiles.git ~/.dotfiles
#   ~/.dotfiles/bootstrap.sh
#
# Safe to re-run: every step checks whether it is already done.

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_THEME="rose-pine"

step() { printf '\n\033[1;34m==>\033[0m \033[1m%s\033[0m\n' "$*"; }
warn() { printf '\033[1;33mwarning:\033[0m %s\n' "$*" >&2; }
has()  { command -v "$1" >/dev/null 2>&1; }

case "$(uname -s)" in
  Darwin) OS=mac ;;
  Linux)  OS=linux ;;
  *)      echo "Unsupported OS: $(uname -s)" >&2; exit 1 ;;
esac

[[ $DOTFILES == "$HOME/.dotfiles" ]] || warn "repo is at $DOTFILES; configs assume ~/.dotfiles"

# --- 1. System prerequisites --------------------------------------------------
step "System prerequisites"
if [[ $OS == mac ]]; then
  if ! xcode-select -p >/dev/null 2>&1; then
    xcode-select --install
    echo "Finish the Command Line Tools install, then re-run this script."
    exit 1
  fi
  echo "Command Line Tools present"
else
  # Homebrew's own requirements + zsh (as the login shell) + clipboard for tmux
  pkgs_apt=(build-essential procps curl file git zsh unzip xclip)
  pkgs_dnf=(gcc gcc-c++ make procps-ng curl file git zsh unzip xclip)
  pkgs_pacman=(base-devel procps-ng curl file git zsh unzip xclip)
  if   has apt-get; then sudo apt-get update && sudo apt-get install -y "${pkgs_apt[@]}"
  elif has dnf;     then sudo dnf install -y "${pkgs_dnf[@]}"
  elif has pacman;  then sudo pacman -S --needed --noconfirm "${pkgs_pacman[@]}"
  else warn "unknown package manager; install manually: ${pkgs_apt[*]}"
  fi
fi

# --- 2. Homebrew + Brewfile ---------------------------------------------------
step "Homebrew"
for brew in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
  [[ -x $brew ]] && { eval "$("$brew" shellenv)"; break; }
done
if ! has brew; then
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  for brew in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
    [[ -x $brew ]] && { eval "$("$brew" shellenv)"; break; }
  done
fi

step "Brewfile packages"
# Keep going on failure: e.g. a cask whose app was already installed by hand.
brew bundle --file "$DOTFILES/Brewfile" || warn "some Brewfile entries failed; see above"

# --- 3. Rust + bob + Neovim ---------------------------------------------------
step "Rust toolchain"
if [[ ! -x $HOME/.cargo/bin/rustup ]]; then
  # --no-modify-path: .zshenv already sources ~/.cargo/env
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi
# shellcheck source=/dev/null
. "$HOME/.cargo/env"

step "Neovim (via bob)"
has bob || cargo install --locked bob-nvim
[[ -x $HOME/.local/share/bob/nvim-bin/nvim ]] || bob use stable
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"

# --- 4. Node (nvm) ------------------------------------------------------------
step "Node via nvm"
export NVM_DIR="$HOME/.nvm"
mkdir -p "$NVM_DIR"
set +u  # nvm.sh is not nounset-safe
# shellcheck source=/dev/null
. "$(brew --prefix nvm)/nvm.sh"
if [[ -z $(ls -A "$NVM_DIR/versions/node" 2>/dev/null) ]]; then
  nvm install --lts
  # Store a concrete version: the lazy loader in .zshrc can't resolve "lts/*"
  nvm alias default "$(nvm version 'lts/*')"
fi
set -u

# --- 5. Symlinks (stow) -------------------------------------------------------
step "Symlinking dotfiles into ~"
cd "$DOTFILES"  # stow reads .stowrc from here
if ! stow_out=$(stow -n . 2>&1); then
  echo "$stow_out"
  echo
  echo "stow found existing files in the way. Back them up or remove them, then re-run."
  echo "(Or 'stow --adopt .' to pull them into the repo, then review with 'git diff'.)"
  exit 1
fi
stow .

# k9s rewrites its config on every run, so copy it rather than link it
# (a link would keep dirtying the repo).
if [[ $OS == mac ]]; then K9S_DIR="$HOME/Library/Application Support/k9s"; else K9S_DIR="$HOME/.config/k9s"; fi
mkdir -p "$K9S_DIR"
[[ -e $K9S_DIR/config.yaml ]] || cp "$DOTFILES/k9s/config.yaml" "$K9S_DIR/config.yaml"

# --- 6. Theme -----------------------------------------------------------------
# tmux.conf and kitty.conf include files that theme-set creates.
step "Colour theme"
if [[ -s $HOME/.theme ]]; then
  "$DOTFILES/theme-set" --reload
else
  "$DOTFILES/theme-set" "$DEFAULT_THEME"
fi
# Follow macOS light/dark mode from now on
[[ $OS == mac ]] && "$DOTFILES/setup_theme_sync"

# --- 7. tmux plugins ----------------------------------------------------------
step "tmux plugin manager"
[[ -d $HOME/.tmux/plugins/tpm ]] || git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"

# --- 8. Neovim plugins --------------------------------------------------------
step "Neovim plugins"
nvim --headless "+Lazy! sync" +qa || warn "Lazy sync failed; open nvim and run :Lazy"

# --- 9. Login shell -----------------------------------------------------------
if [[ $OS == linux && $(basename "${SHELL:-}") != zsh ]]; then
  step "Setting zsh as login shell"
  chsh -s "$(command -v zsh)" || warn "chsh failed; run: chsh -s $(command -v zsh)"
fi

# --- Done ---------------------------------------------------------------------
step "Done. Remaining manual steps:"
cat <<EOF
  1. Open a new terminal; the first start installs zinit + zsh plugins.
  2. In tmux, press prefix (Ctrl-\\) then I to install tmux plugins.
  3. In nvim: let Mason finish installing (:Mason), then :Copilot auth
  4. Machine overlay: create ~/.dotfiles/personal/.zshrc (or tkww/.zshrc)
     for anything machine-specific. See README.md.
EOF
if [[ $OS == mac ]]; then
  echo "  5. Optional: Raycast theme commands, see raycast/README.md"
fi
