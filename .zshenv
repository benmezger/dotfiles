#
# Defines environment variables.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

source $HOME/.zsh/detect_os.zsh

export PATH="$HOME/.bin:$HOME/.virtualenvs/pyenv/bin"
export PATH=$PATH":$HOME/workspace/builds/bin:$HOME/workspace/builds/usr/local/bin"
export PATH=$PATH":$HOME/workspace/builds/usr/bin"
export PATH=$PATH":/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH=$PATH":$HOME/.go/bin"
export GOPATH="$HOME/.go"

if [[ -n $LINUX ]]; then
	export VIRTUALENVWRAPPER_PYTHON="/usr/bin/python2"
	export PATH=$PATH":$HOME/.cask/bin"
elif [[ -n $OSX ]]; then
	export PATH=/usr/texbin:"$PATH"
	export VIRTUALENVWRAPPER_PYTHON="/usr/local/bin/python"
	export PATH=$PATH":$HOME/.rvm/bin"
fi

# general exports

# exports
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/workspace
export EDITOR=vim
export VISUAL=vim
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export KEYTIMEOUT=1 # vim mode key lag
export PYTHONSTARTUP="$HOME/.pythonrc"
export MAKEFLAGS="-j2"
export GPGKEY=0xF2403AC05942EE08

# python
VIRTUAL_ENV_DISABLE_PROMPT=1
source $(which virtualenvwrapper.sh)

# base16
BASE16_SHELL="$HOME/workspace/git/base16-shell/base16-monokai.dark.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

# Set SSH to use gpg-agent
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
    export SSH_AUTH_SOCK="${HOME}/.gnupg/S.gpg-agent.ssh"
fi
