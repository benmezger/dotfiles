export KEYTIMEOUT=1 # vim mode key lag
export PYTHONSTARTUP="$HOME/.pythonrc"


if [[ ${OSTYPE} == darwin* ]]; then
	source $HOME/.zsh/osx.zsh
else
	source $HOME/.zsh/linux.zsh
fi

### Plugins

# zsh prompt
ZSH_GIT_PROMPT_SHOW_STASH=1
source $HOME/.zsh/prompt.zsh

## Tmux autostart
IS_DWM=$(ps aux | grep dwm)
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ] || [ -n "$I3SOCK" ] || [ -n "$IS_DWM" ]; then
	export TMUX_AUTOSTART="false"
else
	export TMUX_AUTOSTART="true"
fi

if [ -f "$HOME/.env-secrets" ]; then
	source "$HOME/.env-secrets"
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

if [ -f "$HOME/.local/bin/poetry" ]; then
	export PATH="$HOME/.poetry/bin:${PATH}"
	export POETRY_VIRTUALENVS_IN_PROJECT=1
fi

export GITLINE_REPO_INDICATOR='${reset}ᚴ'
export GITLINE_BRANCH='[${blue}${branch}${reset}]'
export SLIMLINE_RIGHT_PROMPT_SECTIONS="execution_time git vi_mode exit_status"

# smooth scrolling on firefox
export MOZ_USE_XINPUT2=1

# FZF
export FZF_DEFAULT_OPTS='--height 30% --layout=reverse --border'

# cargo
if [[ -f "$HOME/.cargo/env" ]]; then
	source $HOME/.cargo/env
fi

# 1password. Default to personal account
export OP_ACCOUNT=my.1password.com

export LESS='-F -g -i -M -R -S -w -X -z-4'
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
