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

# prompt theme
#zplug "miekg/lean", as:plugin

# use dotzsh env config
zplug "benmezger/4fbc53631077bd1d2d10faa1dea29830", as:plugin, from:gist, \
    "use:dotenv"

# syntax highlighting
zplug "zsh-users/zsh-syntax-highlighting", defer:3

# prezto modules

# prompt
zplug 'modules/prompt', from:prezto
zstyle ':prezto:module:prompt' theme 'sorin'

# tmux
zplug 'modules/tmux', from:prezto
zstyle ':prezto:module:tmux:auto-start' local 'yes'
zstyle ':prezto:module:tmux:auto-start' remote 'yes'

zplug "modules/completion", as:plugin, from:prezto
zplug "modules/fasd", from:prezto
zplug "modules/git", from:prezto
zplug "modules/history-substring-search", from:prezto
zplug "modules/history", from:prezto

zplug "modules/spectrum", "as:plugin", "from:prezto"
zplug "modules/gpg", as:plugin, "from:prezto"

# python2 virtualenvwrapper
export VIRTUALENVWRAPPER_PYTHON=$(which python2)
zplug "modules/python", "as:plugin", "from:prezto"

# zplug check returns true if all packages are installed
# Therefore, when it returns false, run zplug install
if ! zplug check; then
    zplug install
fi

# Then, source plugins and add commands to $PATH
zplug load

############################# END OF ZPLUG #############################

# zsh variables
HISTFILE="$HOME/.zhistory"
HISTSIZE=10000  # internal history
SAVEHIST=10000  # history file

# zsh options

# history
# from: https://github.com/sorin-ionescu/prezto/blob/master/modules/history/init.zsh
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing non-existent history.

# setopt nohashdirs # zsh rehash
# setopt no_share_history # don't share history

# from https://github.com/sorin-ionescu/prezto/blob/master/modules/directory/init.zsh
setopt AUTO_CD              # Auto changes to a directory without typing cd.
setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
setopt PUSHD_TO_HOME        # Push to home directory when no argument is given.
setopt CDABLE_VARS          # Change directory to a path stored in a variable.
setopt AUTO_NAME_DIRS       # Auto add variable-stored paths to ~ list.
setopt MULTIOS              # Write to multiple descriptors.
setopt EXTENDED_GLOB        # Use extended globbing syntax.
unsetopt CLOBBER            # Do not overwrite existing files with > and >>.
                            # Use >! and >>! to bypass.

## key bindings
# vi mode
bindkey -v

# Use vim cli mode
bindkey '^P' up-history
bindkey '^N' down-history

# backspace and ^h working even after
# returning from command mode
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char

# ctrl-w removed word backwards
bindkey '^w' backward-kill-word

# ctrl-r starts searching history backward
bindkey '^r' history-incremental-search-backward

bindkey -a 'gg' beginning-of-buffer-or-history
bindkey -a 'g~' vi-oper-swap-case # swap case
bindkey -a '^R' redo
bindkey '^G' what-cursor-position
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

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
export LESS='-F -g -i -M -R -S -w -X -z-4'
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true'

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
alias ls="${aliases[ls]:-ls} -G --color=always"
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
alias vim='nvim'

alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index # stack

## Set SSH to use gpg-agent
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
fi
