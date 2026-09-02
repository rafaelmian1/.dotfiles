# ~/.zprofile — login shells only (each new terminal window/tab, tmux panes).
# Environment set here is inherited by every subshell, so put PATH/env setup here
# and keep anything interactive (plugins, aliases, prompt) in ~/.zshrc.
#
# Load order: .zshenv (every zsh) → .zprofile (login) → .zshrc (interactive)

# Homebrew: Apple Silicon, Intel Mac, Linux
for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
  if [[ -x $_brew ]]; then
    eval "$($_brew shellenv)"
    break
  fi
done
unset _brew

export PATH="$HOME/.local/bin:$PATH"
export NVM_DIR="$HOME/.nvm"

# pnpm global packages (`pnpm add -g`). Appended, not prepended, so stray shims
# left there by old pnpm versions can't shadow Homebrew's pnpm.
if [[ $OSTYPE == darwin* ]]; then
  export PNPM_HOME="$HOME/Library/pnpm"
else
  export PNPM_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/pnpm"
fi
export PATH="$PATH:$PNPM_HOME/bin"
