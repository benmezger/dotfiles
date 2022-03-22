#!/usr/bin/env zsh

source $HOME/.zsh/fzf-theme.zsh

fzf-history-widget-accept() {
  fzf-history-widget
  zle accept-line
}

zle -N fzf-history-widget-accept

# directly executing the command (CTRL-X CTRL-R)
bindkey '^X^R' fzf-history-widget-accept
