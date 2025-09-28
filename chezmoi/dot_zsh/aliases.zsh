## aliases

source $HOME/.zsh/git_aliases.zsh 

alias init-completion="rm -f $HOME/.zcompdump; compinit"
alias dotfiles="cd $DOTFILES"
alias workspace="cd $WORKSPACE"
alias fucking='sudo'

alias lessf="less +F"

alias sl='ls' # I often screw this up.
alias s="sudo"
alias c=clear
alias v='vim'

alias editor='$EDITOR'

alias ..="cd .."
alias ...="cd ../../"
alias ....="cd ../../../"
alias .....="cd ../../../../"

alias neomutt="stty discard undef && neomutt"
alias unread="neomutt -f 'notmuch://?query=tag:me and tag:unread'"
alias inbox="neomutt -f 'notmuch://?query=tag:inbox'"
alias me="neomutt -f 'notmuch://?query=tag:me'"
alias archived="neomutt -f 'notmuch://?query=tag:archived'"

# python
alias plocal="poetry env use $(pyenv which python)"
alias u="uv"
alias us="uv sync"
alias ua="uv add"
alias ur="uv run"
alias py="python"

# if exa exist, alias to ls
if (( ${+commands[eza]} )); then
    alias ls='eza'
    alias l='ls'
    alias ll='eza -l'
    alias lll='eza -l | less'
    alias lla='eza -la'
    alias llt='eza -T'
    alias llfu='eza -bghHliS --git'
else
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
fi

if (( $+commands[nvim] )); then
    alias vim="nvim"
fi

if (( $+commands[emacsclient] )); then
    alias e='emacsclient -c -n -a ""'
fi

if (( $+commands[ggrep] )); then
    alias ggrep="ggrep $GREP_OPTIONS"
fi

if [ -f "$HOME/.emacs.d/bin/doom" ]; then
    alias doom="$HOME/.emacs.d/bin/doom"
fi

if (( $+commands[brew] )); then
    brewfile() {cd $HOME/dotfiles && brew bundle "$1" }
    alias tailf="tail -f"
fi

if [[ $+commands[emacs] && -f "$WORKSPACE/blog/org_to_hugo.el" ]]; then
    blog-gen() {
        cd $HOME/workspace/blog/ && emacs \
            --batch \
            -l ~/.emacs.d/init.el \
            -l $HOME/workspace/blog/org_to_hugo.el \
            --eval "(benmezger/org-roam-export-all)"
    }
fi

if (( $+commands[tmuxinator] )); then
    alias mux="tmuxinator"
    alias m="tmuxinator"
fi


if (( $+commands[gist] )); then
    alias gist="gist -p"
fi

if (( $+commands[chezmoi] )); then
    alias cza="chezmoi apply -v"
    alias czadd="chezmoi add -v"
    alias czd="chezmoi diff"
    alias czl="chezmoi git log"
fi

if (( $+commands[pacman] )); then
	alias pac='pacman -S'   # install
	alias pacu='pacman -Syu'    # update, add 'a' to the list of letters to update AUR packages if you use yaourt
	alias pacr='pacman -Rs'   # remove
	alias pacs='pacman -Ss'      # search
	alias paci='pacman -Si'      # info
	alias paclo='pacman -Qdt'    # list orphans
	alias pacro='paclo && sudo pacman -Rns $(pacman -Qtdq)' # remove orphans
	alias pacc='pacman -Scc'    # clean cache
	alias paclf='pacman -Ql'   # list files
fi

if (( $+commands[ledger] )); then
	alias led="ledger --strict -f $LEDGER/main.ledger.gpg --price-db $LEDGER/pricedb.ledger"
	alias bal="led bal"
	alias reg="led reg"
fi

# desktop
alias resurrect-lenin="wakeonlan e8:9c:25:38:4e:a0"
alias unlock-lenin="ssh -t grub 'cryptsetup-askpass'"
alias lenin="ssh lenin"
