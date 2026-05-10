export KEYTIMEOUT=1 # vim mode key lag
export PYTHONSTARTUP="$HOME/.pythonrc"


if [[ ${OSTYPE} == darwin* ]]; then
	source $HOME/.zsh/osx.zsh
else
	source $HOME/.zsh/linux.zsh
fi

if (( $+commands[pyenv] )); then
	source $(pyenv root)/completions/pyenv.zsh
fi

### Plugins

# zsh prompt
ZSH_GIT_PROMPT_SHOW_STASH=1
source $HOME/.zsh/prompt.zsh

## Tmux autostart
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ] || [ -n "$I3SOCK" ] || [ -n "$IS_DWM" ]; then
	export TMUX_AUTOSTART="false"
else
	export TMUX_AUTOSTART="true"
fi

if [ -f "$HOME/.zsh/env-secrets" ]; then
	source "$HOME/.zsh/env-secrets"
fi

export PYENV_VIRTUALENV_DISABLE_PROMPT=1

pyenv() {
	local command
	command="${1:-}"
	if [ "$#" -gt 0 ]; then
		shift
	fi

	case "$command" in
		activate | deactivate | rehash | shell)
			eval "$(pyenv "sh-$command" "$@")"
			;;
		*)
			command pyenv "$command" "$@"
			;;
	esac
}




# FZF
export FZF_DEFAULT_OPTS='--height 30% --layout=reverse --border'
# less colours
if [[ ${PAGER} == 'less' ]]; then
    (( ! ${+LESS_TERMCAP_mb} )) && export LESS_TERMCAP_mb=$'\E[1;31m'   # Begins blinking.
    (( ! ${+LESS_TERMCAP_md} )) && export LESS_TERMCAP_md=$'\E[1;31m'   # Begins bold.
    (( ! ${+LESS_TERMCAP_me} )) && export LESS_TERMCAP_me=$'\E[0m'      # Ends mode.
    (( ! ${+LESS_TERMCAP_se} )) && export LESS_TERMCAP_se=$'\E[0m'      # Ends standout-mode.
    (( ! ${+LESS_TERMCAP_so} )) && export LESS_TERMCAP_so=$'\E[7m'      # Begins standout-mode.
    (( ! ${+LESS_TERMCAP_ue} )) && export LESS_TERMCAP_ue=$'\E[0m'      # Ends underline.
    (( ! ${+LESS_TERMCAP_us} )) && export LESS_TERMCAP_us=$'\E[1;32m'   # Begins underline.
fi


# work related
if [[ -f "$HOME/.zsh/work.zsh" ]]; then
	source $HOME/.zsh/work.zsh
fi
