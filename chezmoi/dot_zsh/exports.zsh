# general exports
export EDITOR=$HOME/.bin/editor
export VISUAL=$HOME/.bin/editor
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export KEYTIMEOUT=1 # vim mode key lag
export PYTHONSTARTUP="$HOME/.pythonrc"

export MAKEFLAGS="-j4 -l5"
if [ -f "$(which nproc)" ]; then
	export MAKEFLAGS="-j$(nproc) -l5"
fi

export GPGKEY=0x7357E344D6C3C795
export SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh

export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true'

export PATH="$HOME/.bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH="$PATH:$HOME/.config/emacs/bin:$HOME/.doom.d/bin"
export PATH="$PATH:/$HOME/.pyenv/bin"
export PATH="$PATH:$HOME/.local/bin"

if [[ ${OSTYPE} == darwin* ]]; then
	source $HOME/.zsh/osx.zsh
else
	source $HOME/.zsh/linux.zsh
fi

export WORKSPACE="$HOME/workspace"
export DOTFILES="$WORKSPACE/dotfiles"
export LEDGER="$WORKSPACE/ledger"

### Plugins

# zsh prompt
ZSH_GIT_PROMPT_SHOW_STASH=1
source $HOME/.zsh/prompt.zsh

# Go path
export GOPATH=$HOME/workspace/go
export PATH="$GOPATH/bin:$PATH"

## Tmux
# autostart tmux
# from: https://github.com/zpm-zsh/tmux/blob/master/tmux.plugin.zsh

# Make sure we are not sshing to this shell or running within an i3 session
IS_DWM=$(ps aux | grep dwm)
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ] || [ -n "$I3SOCK" ] || [ -n "$IS_DWM" ]; then
	export TMUX_AUTOSTART="false"
else
	export TMUX_AUTOSTART="true"
fi

if [ -f "$HOME/.env-secrets" ]; then
	source "$HOME/.env-secrets"
fi

export PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"
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

export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export HTML_TIDY="$HOME/.config/tidyrc"

# smooth scrooling on firefox
export MOZ_USE_XINPUT2=1
export XDG_CONFIG_HOME=$HOME/.config

# FZF
export FZF_DEFAULT_OPTS='--height 30% --layout=reverse --border'
source $HOME/.zsh/fzf-theme.zsh

if [[ -d "$HOME/.local/bin/" ]]; then
	export PATH="$PATH:$HOME/.local/bin/"
fi

# Disabling automatic widget re-binding
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# cargo
if [[ -f "$HOME/.cargo/env" ]]; then
	source $HOME/.cargo/env
fi

# 1password. Default to personal account
export OP_ACCOUNT=my.1password.com

export LESS='-F -g -i -M -R -S -w -X -z-4'
# less Colours
if [[ ${PAGER} == 'less' ]]; then
    (( ! ${+LESS_TERMCAP_mb} )) && export LESS_TERMCAP_mb=$'\E[1;31m'   # Begins blinking.
    (( ! ${+LESS_TERMCAP_md} )) && export LESS_TERMCAP_md=$'\E[1;31m'   # Begins bold.
    (( ! ${+LESS_TERMCAP_me} )) && export LESS_TERMCAP_me=$'\E[0m'      # Ends mode.
    (( ! ${+LESS_TERMCAP_se} )) && export LESS_TERMCAP_se=$'\E[0m'      # Ends standout-mode.
    (( ! ${+LESS_TERMCAP_so} )) && export LESS_TERMCAP_so=$'\E[7m'      # Begins standout-mode.
    (( ! ${+LESS_TERMCAP_ue} )) && export LESS_TERMCAP_ue=$'\E[0m'      # Ends underline.
    (( ! ${+LESS_TERMCAP_us} )) && export LESS_TERMCAP_us=$'\E[1;32m'   # Begins underline.
fi

# grep
export GREP_OPTIONS='-i --color'

# work related
if [[ -f "$HOME/.zsh/work.zsh" ]]; then
	source $HOME/.zsh/work.zsh
fi
