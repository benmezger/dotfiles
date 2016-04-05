#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

bindkey -v # vim mode

# zsh rehash
setopt nohashdirs

# history
setopt no_share_history

# aliases
alias cdworkspace='cd ~/workspace'
alias resource='source ~/.zshrc'
alias dotfiles="cd ~/workspace/git/dotfiles"
alias fucking='sudo'
alias vi='vim'
alias pip-all="pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U"
alias lessf="less +F"
alias tmux="TERM=xterm-256color tmux"

if [[ -n $OSX ]]; then
	alias em="/usr/local/bin/emacsclient -ct"
	alias emg="/usr/local/bin/emacsclient -c > /dev/null 2>&1 &"
	alias es="/usr/local/bin/emacs --daemon"
else
	alias em="/usr/bin/emacsclient -ct"
	alias emg="/usr/bin/emacsclient -c > /dev/null 2>&1 &"
	alias es="/usr/bin/emacs --daemon"
fi

#fasd aliases
alias a='fasd -a'        # any
alias s='fasd -si'       # show / search / select
alias d='fasd -d'        # directory
alias f='fasd -f'        # file
alias sd='fasd -sid'     # interactive directory selection
alias sf='fasd -sif'     # interactive file selection
alias z='fasd_cd -d'     # cd, same functionality as j in autojump
alias zz='fasd_cd -d -i' # cd with interactive selection

# fasd
eval "$(fasd --init auto)"

# solarized colors for xterm
if [[ -n $LINUX ]]; then
	eval `dircolors $HOME/.dircolors`
fi

# key bindings
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

# python
workon pyenv

# extra
if [ -f ~/.zsh/utils.zsh ]; then
	source ~/.zsh/utils.zsh
fi
