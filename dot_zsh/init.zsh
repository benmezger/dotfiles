# General init file

autoload -Uz compinit
compinit -C -i

setopt autocd
setopt extendedglob
setopt NO_NOMATCH
setopt CORRECT

setopt auto_list # automatically list choices on ambiguous completion
setopt auto_menu # automatically use menu completion
setopt always_to_end # move cursor to end if word had one match

# disable keyboard beep
unsetopt BEEP

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

if (( $+commands[dircolors] )); then
    eval $(dircolors -b $HOME/.dircolors )
elif (( $+commands[gdircolors] )); then
    eval $(gdircolors -b $HOME/.dircolors )
fi

## Pyenv
if (( ${+commands[pyenv]} )); then
    eval "$(pyenv init - zsh --no-rehash)"
    eval "$(pyenv virtualenv-init -)"
fi

# from: http://www.zsh.org/mla/users/2001/msg00870.html
custom-backward-delete-word() {
    local WORDCHARS=${WORDCHARS/\//}
    zle backward-delete-word
}

zle -N custom-backward-delete-word
bindkey '^W' custom-backward-delete-word


if (( ${+commands[pyenv]} )); then
    export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
    export PYENV_VIRTUALENV_DISABLE_PROMPT=1
    eval "$(pyenv init - zsh --no-rehash)"
    eval "$(pyenv virtualenv-init -)"
    . $(pyenv root)/completions/pyenv.zsh
fi

# check if z.lua exists and initialize it
if [[ ${OSTYPE} == darwin* ]]; then
    if [ -f "/usr/local/share/z.lua/z.lua.plugin.zsh" ]; then
        eval "$(lua /usr/local/share/z.lua/z.lua --init zsh enhanced once echo fzf)"
    fi
fi


# heroku autocomplete setup
HEROKU_AC_ZSH_SETUP_PATH=$HOME/.cache/heroku/autocomplete/zsh_setup \
    && test -f $HEROKU_AC_ZSH_SETUP_PATH \
    && source $HEROKU_AC_ZSH_SETUP_PATH

# setup custom completion path
fpath=($HOME/.zsh/completions $fpath)
