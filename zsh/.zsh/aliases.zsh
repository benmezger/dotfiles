## aliases
alias dotfiles="cd ~/dotfiles"
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
alias ipy="python -c 'import IPython; IPython.frontend.terminal.ipapp.launch_new_instance()'"

# fasd aliases
alias a='fasd -a'        # any
alias s='fasd -si'       # show / search / select
alias d='fasd -d'        # directory
alias f='fasd -f'        # file
alias sd='fasd -sid'     # interactive directory selection
alias sf='fasd -sif'     # interactive file selection
alias z='fasd_cd -d'     # cd, same functionality as j in autojump
alias zz='fasd_cd -d -i' # cd with interactive selection
