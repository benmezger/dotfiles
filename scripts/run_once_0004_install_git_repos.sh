#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="${SOURCE_DIR:-$(dirname "$(pwd)")}"
. "$SOURCE_DIR/scripts/buildcheck.sh"

ZPLUG_PATH="$HOME/.zplug"
if [ ! -d "$ZPLUG_PATH" ]; then
    git clone https://github.com/zplug/zplug "$ZPLUG_PATH"
fi

TMUX_TPM_PATH="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TMUX_TPM_PATH" ]; then
    mkdir -p "$TMUX_TPM_PATH"
    git clone https://github.com/tmux-plugin/tpm "$TMUX_TPM_PATH"
fi

VIM_PLUG_PATH="$HOME/.vim/autoload"
if [ ! -d "$VIM_PLUG_PATH" ]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    if ! [ -x "$(command -v nvim)" ]; then
        nvim +PlugInstall +qall --headless
    fi
fi

BASE16_PATH="$HOME/.config/base16-shell"
if [ ! -d "$BASE16_PATH" ]; then
    mkdir -p "$BASE16_PATH"
    git clone https://github.com/chriskempson/base16-shell "$BASE16_PATH"
fi

EMACS_PATH="$HOME/.emacs.d"
if [ ! -d "$EMACS_PATH" ]; then
    mkdir -p "$EMACS_PATH"
    git clone --depth 1 https://github.com/hlissner/doom-emacs "$EMACS_PATH"
    "$EMACS_PATH"/bin/doom -y install
else
    "$EMACS_PATH"/bin/doom -y sync -e
fi
