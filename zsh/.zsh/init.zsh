# General init file

autoload -Uz compinit
compinit -C -i

setopt autocd
setopt extendedglob
setopt NO_NOMATCH

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
export GPGKEY=0xF2403AC05942EE08
export PATH="${PATH}:$HOME/.bin"
export LESS='-F -g -i -M -R -S -w -X -z-4'
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true'
export SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh

# colors
export LSCOLORS='exfxcxdxbxGxDxabagacad'
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'
export GREP_COLOR='37;45' # BSD.
export GREP_COLORS="mt=$GREP_COLOR" # GNU.


# navidate completion
zstyle ':completion:*' menu select

# slimline
export SLIMLINE_PROMPT_VERSION=1 # activate legacy option format
export SLIMLINE_ENABLE_ASYNC_AUTOLOAD=0

# automatically start tmux
export ZSH_TMUX_AUTOSTART=1

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi
