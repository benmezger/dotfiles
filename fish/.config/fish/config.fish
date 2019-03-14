# Install fisher
if not functions -q fisher
    echo "Installing fisher for the first time..." >&2
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fisher
end

# fish config
fish_vi_key_bindings

# Set base16 theme
base16 monokai

# pyenv
status --is-interactive; and source (pyenv init -| psub)


# exports
set -g -x WORKON_HOME "$HOME/.virtualenvs"
set -g -x PROJECT_HOME "$HOME/workspace"
set -g -x EDITOR nvim
set -g -x VISUAL nvim
set -g -x LC_ALL en_US.UTF-8
set -g -x LANG en_US.UTF-8
set -g -x KEYTIMEOUT 1 # vim mode key lag
set -g -x PYTHONSTARTUP "$HOME/.pythonrc"
set -g -x MAKEFLAGS "-j4 -l5"
set -g -x GPGKEY 0xF2403AC05942EE08
set -g -x PATH $PATH "$HOME/.bin"
set -g -x LESS '-F -g -i -M -R -S -w -X -z-4'
set -g -x SSH_AUTH_SOCK $HOME/.gnupg/S.gpg-agent.ssh
set -g -x RIPGREP_CONFIG_PATH ~/.ripgreprc

# colors
set -g -x LSCOLORS 'exfxcxdxbxGxDxabagacad'
set -g -x LS_COLORS 'di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'
set -g -x GREP_COLOR '37;45' # BSD.
set -g -x GREP_COLORS "mt=$GREP_COLOR" # GNU.

# colorful man pages
set -x LESS_TERMCAP_mb (printf "\033[01;31m")
set -x LESS_TERMCAP_md (printf "\033[01;31m")
set -x LESS_TERMCAP_me (printf "\033[0m")
set -x LESS_TERMCAP_se (printf "\033[0m")
set -x LESS_TERMCAP_so (printf "\033[01;44;33m")
set -x LESS_TERMCAP_ue (printf "\033[0m")
set -x LESS_TERMCAP_us (printf "\033[01;32m")

switch (uname)
    case Darwin
        set -g -x HOMEBREW_NO_AUTO_UPDATE 1
        set -g -x HOMEBREW_NO_ANALYTICS 1
end

if type -q emerge  # is distro is Gentoo, then set  the following variables
    set -g -x NUMCPUS (nproc)
    set -g -x NUMCPUSPLUSONE $NUMCPUS + 1
    set -g -x MAKEOPTS="-j$NUMCPUSPLUSONE -l$NUMCPUS"
    set -g -x EMERGE_DEFAULT_OPTS="--jobs=$NUMCPUSPLUSONE --load-average=$NUMCPUS"
end

## aliases
alias dotfiles "cd ~/dotfiles"
alias fucking 'sudo'
alias vi "vim"
alias lessf "less +F"
alias l 'ls -1A'         # Lists in one column, hidden files.
alias ll 'ls -lh'        # Lists human readable sizes.
alias lr 'll -R'         # Lists human readable sizes, recursively.
alias la 'll -A'         # Lists human readable sizes, hidden files.
alias lm 'la | "$PAGER"' # Lists human readable sizes, hidden files through pager.
alias lx 'll -XB'        # Lists sorted by extension (GNU only).
alias lk 'll -Sr'        # Lists sorted by size, largest last.
alias lt 'll -tr'        # Lists sorted by date, most recent last.
alias lc 'lt -c'         # Lists sorted by date, most recent last, shows change time.
alias lu 'lt -u'         # Lists sorted by date, most recent last, shows access time.
alias sl 'ls' # I often screw this up.
alias vim "nvim"

# fasd aliases
alias a 'fasd -a'        # any
alias s 'fasd -si'       # show / search / select
alias d 'fasd -d'        # directory
alias f 'fasd -f'        # file
alias sd 'fasd -sid'     # interactive directory selection
alias sf 'fasd -sif'     # interactive file selection
alias z 'fasd_cd -d'     # cd, same functionality as j in autojump
alias zz 'fasd_cd -d -i' # cd with interactive selection

# source custom files
source $HOME/.config/fish/functions/vim_prompt.fish
source $HOME/.config/fish/functions/start_tmux.fish
source $HOME/.config/fish/functions/fasd_cd.fish
source $HOME/.config/fish/functions/env.fish

# tmux auto start local
set -U TMUX_AUTO_START_LOCAL 1

if status is-interactive >/dev/null
    set -q TMUX_AUTO_START_LOCAL;  or set -U TMUX_AUTO_START_LOCAL  0
    set -q TMUX_AUTO_START_REMOTE; or set -U TMUX_AUTO_START_REMOTE 0
    __tmux_start
end

function fish_greeting
    fortune -a -s
end

set -U fish_ambiguous_width 1
