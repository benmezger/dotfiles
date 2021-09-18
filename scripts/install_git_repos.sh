#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
. "$DIR/base.sh"

VIM_PLUG_PATH="$HOME/.vim/autoload/plug.vim"
if [[ -f "$VIM_PLUG_PATH" && -x "$(command -v nvim)" ]]; then
	nvim +PlugInstall +qall --headless
fi

EMACS_PATH="$HOME/.emacs.d"
if [ ! -f "$EMACS_PATH/bin/doom" ]; then
	mkdir -p "$EMACS_PATH"
	git clone --depth 1 https://github.com/hlissner/doom-emacs "$EMACS_PATH"
	"$EMACS_PATH/bin/doom" -y install
else
	"$EMACS_PATH/bin/doom" -y sync -e
fi

NOTES_PATH="/usr/local/bin/notes"
if [ ! -f "$NOTES_PATH" ]; then
	curl -L https://raw.githubusercontent.com/pimterry/notes/latest-release/install.sh | bash
fi
