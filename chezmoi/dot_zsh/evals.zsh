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
	# The hook registers _direnv_hook on both precmd (every prompt) and chpwd
	# (directory change). The precmd registration causes ~8ms overhead on every
	# prompt draw. Removing it from precmd_functions keeps direnv running only
	# on directory changes (chpwd), saving ~8ms/prompt.
	#
	# Tradeoff: if we edit an .envrc while already in that directory, it won't
	# auto-reload. For that, we need to run `direnv reload` manually or `cd .`.
	precmd_functions=(${precmd_functions:#_direnv_hook})
fi

if (( $+commands[terraform] )); then
    autoload -U +X bashcompinit && bashcompinit
    complete -o nospace -C terraform terraform
fi
