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
export {http,https,ftp}_proxy="localhost:8118"

# python
VIRTUAL_ENV_DISABLE_PROMPT=1
source $(which virtualenvwrapper.sh)
