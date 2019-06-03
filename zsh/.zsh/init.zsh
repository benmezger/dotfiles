# General init file

autoload -Uz compinit
compinit -C -i

setopt autocd
setopt extendedglob
setopt NO_NOMATCH
setopt CORRECT

setopt auto_list # automatically list choices on ambiguous completion
setopt auto_menu # automatically use menu completion
setopt always_to_end # move cursor to end if word had one match

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


# navidate completion
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
_approximate # enable approximate matches for completion


# slimline
export SLIMLINE_PROMPT_VERSION=1 # activate legacy option format
export SLIMLINE_ENABLE_ASYNC_AUTOLOAD=0

# automatically start tmux
export ZSH_TMUX_AUTOSTART=1

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"


if [[ ${OSTYPE} == darwin* ]]; then
    export HOMEBREW_NO_AUTO_UPDATE=1
fi

if (( ${+commands[pyenv]} )); then
    eval "$(pyenv init -)"
fi


# autostart tmux
# from: https://github.com/zpm-zsh/tmux/blob/master/tmux.plugin.zsh
export TMUX_AUTOSTART="true"

function _tmux_autostart(){
  if [[ "$TMUX_AUTOSTART" == "true" && -z "$TMUX" ]]; then
    tmux attach || TERM=xterm-256color tmux new
    exit 0
  fi
  precmd_functions=(${precmd_functions#_tmux_autostart})
}

precmd_functions+=( _tmux_autostart )

#  load LS_COLORS
eval $(dircolors -b $HOME/.dircolors)

if [ -f $HOME/.env-secrets ]; then
    # load secret env if it exists
    source $HOME/.env-secrets
fi

# check if fasd exists and initialize it
if (( ${+commands[fasd]} )); then
    eval "$(fasd --init auto)"
fi

