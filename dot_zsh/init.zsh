# General init file

setopt autocd
setopt extendedglob
setopt NO_NOMATCH
setopt CORRECT

setopt auto_list # automatically list choices on ambiguous completion
setopt auto_menu # automatically use menu completion
setopt always_to_end # move cursor to end if word had one match

# Print a carriage return just before printing a prompt in the line editor
# and try to preserve a partial line.
setopt promptcr promptsp

# disable keyboard beep
unsetopt BEEP

## Tmux
_tmux_autostart(){
    if [[ "$TMUX_AUTOSTART" == "true" && -z "$TMUX" ]]; then
        tmux attach || tmux new
        exit 0
    fi
}

_fix_cursor() {
   echo -ne '\e[5 q'
}

precmd_functions+=(_tmux_autostart _fix_cursor)

# setup custom completion path
fpath=($HOME/.zsh/completions $fpath)

autoload -Uz compinit

# navidate completion
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

profzsh() {
	shell=${1-$SHELL}
	ZPROF=true $shell -i -c exit
}

autoload edit-command-line
zle -N edit-command-line
