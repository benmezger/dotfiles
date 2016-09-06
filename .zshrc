#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

bindkey -v # vim mode

# zsh rehash
setopt nohashdirs

# history
setopt no_share_history

# fasd
eval "$(fasd --init auto)"

# key bindings
# Use vim cli mode
bindkey '^P' up-history
bindkey '^N' down-history

# backspace and ^h working even after
# returning from command mode
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char

# ctrl-w removed word backwards
bindkey '^w' backward-kill-word

# ctrl-r starts searching history backward
bindkey '^r' history-incremental-search-backward

bindkey -a 'gg' beginning-of-buffer-or-history
bindkey -a 'g~' vi-oper-swap-case # swap case
bindkey -a '^R' redo
bindkey '^G' what-cursor-position
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

# source fzf
source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh

# use pyenv as default python env
workon pyenv
