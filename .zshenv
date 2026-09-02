# ~/.zshenv — read by EVERY zsh, including scripts and non-interactive shells.
# Keep it tiny: only PATH entries that even `zsh -c '...'` needs.
#
# Load order: .zshenv (every zsh) → .zprofile (login) → .zshrc (interactive)

# Rust toolchain (rustup / cargo)
[[ -f $HOME/.cargo/env ]] && . "$HOME/.cargo/env"

# Neovim, managed by bob
[[ -f $HOME/.local/share/bob/env/env.sh ]] && . "$HOME/.local/share/bob/env/env.sh"
