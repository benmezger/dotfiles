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
export PATH=$PATH":$HOME/Workspace/builds/bin:$HOME/Workspace/builds/usr/local/bin"
export PATH=$PATH":$HOME/Workspace/builds/usr/bin"
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
export PROJECT_HOME=$HOME/Workspace
export EDITOR=vim
export VISUAL=vim
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export KEYTIMEOUT=1 # vim mode key lag
export PYTHONSTARTUP="$HOME/.pythonrc"
export MAKEFLAGS="-j2"
export GPGKEY=C6C2927E
export EMAIL="mezger.benjamin@gmail.com"
export NAME="Ben Mezger"
export SMTPSERVER="smtp.gmail.com"

# python
VIRTUAL_ENV_DISABLE_PROMPT=1
source $(which virtualenvwrapper.sh)
