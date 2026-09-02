# ~/.zshrc — interactive shells. Environment/PATH lives in ~/.zprofile.
#
# Machine overlays: ~/.dotfiles/personal/.zshrc and ~/.dotfiles/tkww/.zshrc are
# sourced at the very end if present (both gitignored), so they can override anything.

# An overlay that still sources ~/.zshrc would recurse forever — bail out.
[[ -n $_DOTFILES_IN_OVERLAY ]] && return

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

DOTFILES="$HOME/.dotfiles"
typeset -U path fpath  # dedupe PATH entries when shells nest

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light jeffreytse/zsh-vi-mode
zinit load z-shell/H-S-MW

ZVM_VI_EDITOR=nvim

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# Load completions — once. The full security check (compaudit) and dump rebuild
# only run when the dump is older than 24h; otherwise use the cached dump (-C).
# New completions not showing up? `rm ~/.zcompdump && exec zsh`
fpath=($HOME/.docker/completions $fpath)
autoload -Uz compinit
() {
  setopt local_options extended_glob
  local dump=${ZDOTDIR:-$HOME}/.zcompdump
  if [[ -n $dump(#qN.mh+24) ]]; then
    compinit -d $dump
  else
    compinit -C -d $dump
  fi
}

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu yes
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd go zsh)"
eval "$(direnv hook zsh)"

# Node: nvm is lazy-loaded on first `nvm` call (sourcing nvm.sh costs ~300ms).
# The default node version is put on PATH directly so node/npm work right away.
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
() {
  local default=$NVM_DIR/alias/default bins
  [[ -r $default ]] || return
  default=$(<$default)
  bins=($NVM_DIR/versions/node/v${default#v}*/bin(Nn))
  (( $#bins )) && path=($bins[-1] $path)
}
nvm() {
  unfunction nvm
  local prefix=${HOMEBREW_PREFIX:-/opt/homebrew}/opt/nvm
  [[ -s $prefix/nvm.sh ]] && source $prefix/nvm.sh
  [[ -s $prefix/etc/bash_completion.d/nvm ]] && source $prefix/etc/bash_completion.d/nvm
  nvm "$@"
}

# Neovim Remote
if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
    export VISUAL="nvr -cc split --remote-wait +'set bufhidden=wipe'"
    export EDITOR="nvr -cc split --remote-wait +'set bufhidden=wipe'"
else
    export VISUAL="nvim"
    export EDITOR="nvim"
fi

export DISABLE_AUTO_TITLE='true'

# Aliases & helpers
source $DOTFILES/.zsh_aliases

# Machine overlays (gitignored) — loaded last so they can override anything above.
_DOTFILES_IN_OVERLAY=1
for _overlay in $DOTFILES/{personal,tkww}/.zshrc(N); do
  source $_overlay
done
unset _overlay _DOTFILES_IN_OVERLAY
