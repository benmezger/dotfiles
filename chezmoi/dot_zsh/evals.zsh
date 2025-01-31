#!/usr/bin/env zsh

if (( $+commands[dircolors] )); then
	eval $(dircolors -b $HOME/.dircolors)
elif (( $+commands[gdircolors] )); then
	eval $(gdircolors -b $HOME/.dircolors)
fi

if [ -n "${TMUX+1}" ]; then
	if (($+commands[tmux])); then
		tmux set-environment -g PATH $PATH
	fi
fi

if (( $+commands[direnv] )); then
	eval "$(direnv hook zsh)"
fi
