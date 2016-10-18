# source zplug
source ~/.zplug/init.zsh

# manage zplug itself
zplug "zplug/zplug"

# use double quotes - up-arrow history
zplug "zsh-users/zsh-history-substring-search"

# additional completion for zsh
# zplug "zsh-users/zsh-completions"

# zsh auto suggestions based on my history
zplug "zsh-users/zsh-autosuggestions"

# base16-shell
BASE16_SCHEME="monokai"
zplug "chriskempson/base16-shell", use:"scripts/base16-$BASE16_SCHEME.sh"

# prompt theme - TODO: find a better prompt
zplug "cusxio/delta-prompt"
# zplug "yous/lime"

# prezto modules
# load gpg from prezto
zplug "modules/gpg", "from:prezto"
zplug "modules/completion", "from:prezto"

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

# colors
export LSCOLORS='exfxcxdxbxGxDxabagacad'
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'
export GREP_COLOR='37;45' # BSD.
export GREP_COLORS="mt=$GREP_COLOR" # GNU.

## aliases
alias dotfiles="cd ~/workspace/git/dotfiles"
alias fucking='sudo'
alias vi="vim"
alias pip-all="pip freeze --local | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip install -U"
alias lessf="less +F"
alias tmux="TERM=xterm-256color tmux"
alias ccat='pygmentize -g -O style=colorful,linenos=1'
alias ls="${aliases[ls]:-ls} -G"
alias l='ls -1A'         # Lists in one column, hidden files.
alias ll='ls -lh'        # Lists human readable sizes.
alias lr='ll -R'         # Lists human readable sizes, recursively.
alias la='ll -A'         # Lists human readable sizes, hidden files.
alias lm='la | "$PAGER"' # Lists human readable sizes, hidden files through pager.
alias lx='ll -XB'        # Lists sorted by extension (GNU only).
alias lk='ll -Sr'        # Lists sorted by size, largest last.
alias lt='ll -tr'        # Lists sorted by date, most recent last.
alias lc='lt -c'         # Lists sorted by date, most recent last, shows change time.
alias lu='lt -u'         # Lists sorted by date, most recent last, shows access time.
alias sl='ls' # I often screw this up.
alias grep="${aliases[grep]:-grep} --color=auto"

# fasd aliases
alias a='fasd -a'        # any
alias s='fasd -si'       # show / search / select
alias d='fasd -d'        # directory
alias f='fasd -f'        # file
alias sd='fasd -sid'     # interactive directory selection
alias sf='fasd -sif'     # interactive file selection
alias z='fasd_cd -d'     # cd, same functionality as j in autojump
alias zz='fasd_cd -d -i' # cd with interactive selection
