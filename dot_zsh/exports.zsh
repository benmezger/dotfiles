# general exports
export PROJECT_HOME=$HOME/workspace
export EDITOR=$HOME/.bin/editor
export VISUAL=$HOME/.bin/editor
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export KEYTIMEOUT=1 # vim mode key lag
export PYTHONSTARTUP="$HOME/.pythonrc"
export MAKEFLAGS="-j4 -l5"
export GPGKEY=0x7357E344D6C3C795
export LESS='-F -g -i -M -R -S -w -X -z-4'
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true'
export SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

if [[ ${OSTYPE} == darwin* ]]; then
	export HOMEBREW_NO_AUTO_UPDATE=1
	# fzf
	source /usr/local/opt/fzf/shell/key-bindings.zsh
	source /usr/local/opt/fzf/shell/completion.zsh
else
	# fzf
	source /usr/share/fzf/key-bindings.zsh
	source /usr/share/fzf/completion.zsh
fi

export PATH="$HOME/.bin:$PATH"

export WORKSPACE="$HOME/workspace"
export RISCV_PATH="$WORKSPACE/opt/riscv64gc"

if [[ -d $RISCV_PATH ]]; then
	export PATH="$RISCV_PATH/bin:$PATH"
fi

### Plugins

## Slimline
export SLIMLINE_ENABLE_ASYNC_AUTOLOAD=0

# Go path
export GOPATH=$HOME/workspace/go
export PATH=$GOPATH/bin:$PATH

## Autoenv
export AUTOENV_FILE_ENTER=".hi"
export AUTOENV_FILE_LEAVE=".bye"

## Tmux
# autostart tmux
# from: https://github.com/zpm-zsh/tmux/blob/master/tmux.plugin.zsh

# Make sure we are not sshing to this shell or running within an i3 session
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ] || [ -n "$I3SOCK" ]; then
	export TMUX_AUTOSTART="false"
else
	export TMUX_AUTOSTART="true"
fi

if [ -f "$HOME/.env-secrets" ]; then
	source "$HOME/.env-secrets"
fi

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export WORKON_HOME=$HOME/.virtualenvs

# FZF
export FZF_DEFAULT_OPTS='--height 30% --layout=reverse --border'

if [ -f "$HOME/.poetry/bin/poetry" ]; then
	export PATH="$HOME/.poetry/bin:${PATH}"
fi

export GITLINE_REPO_INDICATOR='${reset}ᚴ'
export GITLINE_BRANCH='[${blue}${branch}${reset}]'
export SLIMLINE_RIGHT_PROMPT_SECTIONS="execution_time git vi_mode exit_status"
