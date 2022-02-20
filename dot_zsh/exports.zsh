# general exports
export PROJECT_HOME=$HOME/workspace
export EDITOR=$HOME/.bin/editor
export VISUAL=$HOME/.bin/editor
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export KEYTIMEOUT=1 # vim mode key lag
export PYTHONSTARTUP="$HOME/.pythonrc"
export MAKEFLAGS="-j4 -l5"

if [ -f "$(which nproc)" ]; then
	export MAKEFLAGS="-j$(nproc) -l5"
else
	export MAKERANGE="-j5 -l5"
fi

export GPGKEY=0x7357E344D6C3C795
export LESS='-F -g -i -M -R -S -w -X -z-4'
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true'
export SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

if [[ ${OSTYPE} == darwin* ]]; then
	export HOMEBREW_NO_AUTO_UPDATE=1
	export HOMEBREW_VERBOSE_USING_DOTS=1
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
export RISCV_PATH="/opt/riscv/"

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
export PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"
export WORKON_HOME=$HOME/.virtualenvs

# FZF
export FZF_DEFAULT_OPTS='--height 30% --layout=reverse --border'

if [ -f "$HOME/.poetry/bin/poetry" ]; then
	export PATH="$HOME/.poetry/bin:${PATH}"
fi

export GITLINE_REPO_INDICATOR='${reset}ᚴ'
export GITLINE_BRANCH='[${blue}${branch}${reset}]'
export SLIMLINE_RIGHT_PROMPT_SECTIONS="execution_time git vi_mode exit_status"

if [[ -d "/Library/TeX/texbin" ]]; then
	export PATH="$PATH:/Library/TeX/texbin"
fi

export ORGANIZE_CONFIG=$HOME/.config/organize-tool/config.yaml
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export HTML_TIDY="$HOME/.config/tidyrc"

if [[ ${OSTYPE} == darwin* ]]; then
	export ZSH_WAKATIME_BIN="/usr/local/bin/wakatime-cli"
else
	export ZSH_WAKATIME_BIN="/usr/bin/wakatime"
fi

# smooth scrooling on firefox
export MOZ_USE_XINPUT2=1
export XDG_CONFIG_HOME=$HOME/.config

if [[ ${OSTYPE} == linux* ]]; then
	export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
	export DEBUGINFOD_URLS="https://debuginfod.elfutils.org"
fi


if [[ -d "$HOME/workspace/quartus/quartus" ]]; then
	export QSYS_ROOTDIR="$HOME/workspace/quartus/quartus/sopc_builder/bin"
	export PATH="$PATH:$HOME/workspace/quartus/quartus/bin"
fi

if [[ -d "/opt/xilinx/Vivado/2021.2/bin" ]]; then
	export PATH="$PATH:/opt/xilinx/Vivado/2021.2/bin"
fi

export vblank_mode=1
