# Dependencies of these dotfiles — `brew bundle --file ~/.dotfiles/Brewfile`
# Works on macOS and Linux (Homebrew on Linux); mac-only entries are guarded.
# On Linux, zsh/unzip/xclip come from the system package manager (bootstrap.sh).
# This is only what the configs here need. Other tools you use go in your own list.

tap "fluxcd/tap"
tap "hashicorp/tap"

# --- Shell (.zshrc, .zsh_aliases) ---------------------------------------------
brew "git"
brew "stow"        # symlinks this repo into ~
brew "fzf"         # Ctrl-R, fzf-tab, kube/s3 pickers
brew "zoxide"      # `go` (cd replacement)
brew "direnv"
brew "eza"         # `ls`
brew "nvm"         # lazy-loaded in .zshrc
brew "pnpm"        # `pn`

# --- Neovim (nvim itself comes from bob, see bootstrap.sh) ---------------------
brew "ripgrep"     # telescope live grep
brew "fd"          # telescope find files
brew "make"        # telescope-fzf-native build
brew "tree-sitter"
brew "python"      # mason: basedpyright, ruff, debugpy
brew "wget"

# --- tmux ---------------------------------------------------------------------
brew "tmux"
brew "tmuxp"       # tmux_session (ts / tsw / tss)
brew "jq"          # tmux-powerline segments

# --- Git ----------------------------------------------------------------------
brew "lazygit"     # `lz`
brew "git-delta"   # lazygit pager (themes/*/lazygit-*.yml)

# --- Kubernetes / cloud (aliases in .zsh_aliases) -----------------------------
brew "kubernetes-cli"
brew "kubectx"     # kctx / kns
brew "k9s"
brew "fluxcd/tap/flux"  # fgk / frk
brew "awscli"      # s3* helpers
brew "hashicorp/tap/terraform"  # `tf`

# --- macOS only -----------------------------------------------------------------
if OS.mac?
  tap "cormacrelf/tap"
  brew "cormacrelf/tap/dark-notify"  # nvim + theme-set follow light/dark mode
  cask "kitty"
  cask "font-jetbrains-mono-nerd-font"  # kitty font; also p10k/eza icons
end
