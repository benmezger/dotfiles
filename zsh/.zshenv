# general exports
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/workspace
export EDITOR=vim
export VISUAL=vim
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export KEYTIMEOUT=1 # vim mode key lag
export PYTHONSTARTUP="$HOME/.pythonrc"
export MAKEFLAGS="-j4 -l5"
export GPGKEY=0xAC7A30843ADC0D65
export PATH="${PATH}:$HOME/.bin"
export LESS='-F -g -i -M -R -S -w -X -z-4'
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true'
export SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh

### Plugins

## Slimline
export SLIMLINE_PROMPT_VERSION=1 # activate legacy option format
export SLIMLINE_ENABLE_ASYNC_AUTOLOAD=0

## Homebrew
if [[ ${OSTYPE} == darwin* ]]; then
    export HOMEBREW_NO_AUTO_UPDATE=1
fi

## Pyenv
if (( ${+commands[pyenv]} )); then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
    eval "$(pyenv init -)"
fi

# Rbenv
if (( ${+commands[rbenv]} )); then
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
fi

## Autoenv
export AUTOENV_FILE_ENTER=".hi"
export AUTOENV_FILE_LEAVE=".bye"

## Tmux
# autostart tmux
# from: https://github.com/zpm-zsh/tmux/blob/master/tmux.plugin.zsh
export TMUX_AUTOSTART="true"
