bindkey -v

# vi mode mishandles bracketed-paste ESC/~ sequences; last char gets swapcased
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic
bindkey -M viins '^[[200~' bracketed-paste
bindkey -M vicmd '^[[200~' bracketed-paste

bindkey '\ew' kill-region
bindkey -s '\el' "ls\n"
bindkey "^[[5~" up-line-or-history
bindkey "^[[6~" down-line-or-history
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
bindkey "^[[H" beginning-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[OH" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[4~" end-of-line
bindkey "^[OF" end-of-line
bindkey ' ' magic-space
bindkey "^F" forward-word
bindkey "^B" backward-word
bindkey '^[[Z' reverse-menu-complete
bindkey '^?' backward-delete-char
bindkey "^[[3~" delete-char
bindkey "^[3;5~" delete-char
bindkey "\e[3~" delete-char
bindkey '^r' fzf-history-widget

# from: http://www.zsh.org/mla/users/2001/msg00870.html
custom-backward-delete-word() {
    local WORDCHARS=${WORDCHARS/\//}
    zle backward-delete-word
}

zle -N custom-backward-delete-word
bindkey '^W' custom-backward-delete-word

custom-edit-command-line() {
    local VISUAL=nvim
    zle edit-command-line
}

zle -N custom-edit-command-line
bindkey -M vicmd v custom-edit-command-line
