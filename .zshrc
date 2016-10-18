# source zplug
source ~/.zplug/init.zsh

# manage zplug itself
zplug "zplug/zplug"

# use double quotes - up-arrow history
zplug "zsh-users/zsh-history-substring-search"

# additional completion for zsh
zplug "zsh-users/zsh-completions"

# zsh auto suggestions based on my history
zplug "zsh-users/zsh-autosuggestions"

# base16-shell
BASE16_SCHEME="monokai"
zplug "chriskempson/base16-shell", use:"scripts/base16-$BASE16_SCHEME.sh"

# prompt theme - TODO: find a better prompt
zplug "cusxio/delta-prompt"
# zplug "yous/lime"

# load gpg from prezto
zplug "modules/gpg", "from:prezto"

# zplug check returns true if all packages are installed
# Therefore, when it returns false, run zplug install
if ! zplug check; then
    zplug install
fi

# Then, source plugins and add commands to $PATH
zplug load

############################# END OF ZPLUG #############################

# zsh variables
HISTFILE="~/.zhistory"
HISTSIZE=10000  # internal history
SAVEHIST=10000  # history file

# zsh options
setopt HIST_IGNORE_SPACE # do not record an event starting with a space
setopt SHARE_HISTORY # share history between sessions
setopt INC_APPEND_HISTORY # write to the history file immediately, not when the shell exits

## key bindings
# vi mode
bindkey -v

# exports
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

## aliases
alias dotfiles="cd ~/workspace/git/dotfiles"
alias fucking='sudo'
alias vi="vim"
alias pip-all="pip freeze --local | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip install -U"
alias lessf="less +F"
alias tmux="TERM=xterm-256color tmux"
alias ccat='pygmentize -g -O style=colorful,linenos=1'

# fasd aliases
alias a='fasd -a'        # any
alias s='fasd -si'       # show / search / select
alias d='fasd -d'        # directory
alias f='fasd -f'        # file
alias sd='fasd -sid'     # interactive directory selection
alias sf='fasd -sif'     # interactive file selection
alias z='fasd_cd -d'     # cd, same functionality as j in autojump
alias zz='fasd_cd -d -i' # cd with interactive selection
