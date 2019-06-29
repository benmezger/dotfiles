# General init file

source $HOME/.zsh/env.zsh

autoload -Uz compinit
compinit -C -i

setopt autocd
setopt extendedglob
setopt NO_NOMATCH
setopt CORRECT

setopt auto_list # automatically list choices on ambiguous completion
setopt auto_menu # automatically use menu completion
setopt always_to_end # move cursor to end if word had one match

# navidate completion
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
_approximate # enable approximate matches for completion

## Tmux
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

# check if fasd exists and initialize it
if (( ${+commands[fasd]} )); then
    eval "$(fasd --init auto)"
fi

if (( $+commands[dircolors] )); then
    eval $(dircolors -b $HOME/.dircolors )
elif (( $+commands[gdircolors] )); then
    eval $(gdircolors -b $HOME/.dircolors )
fi
