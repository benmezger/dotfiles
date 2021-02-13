#!/usr/bin/env bash
set -euo pipefail

DIR=$(dirname "$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)")
. "$DIR/scripts/buildcheck.sh"
. "$DIR/scripts/base.sh"
. "$DIR/scripts/ansi"

export HOMEBREW_BUNDLE_FILE="$DIR/Brewfile"
PACMAN_BUNDLE_FILE="$DIR/Pacfile"

if [[ "$OSTYPE" == "darwin"* ]]; then
	ansi --green "Using $HOMEBREW_BUNDLE_FILE bundle file"
	brew bundle
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
	ansi --green "Using $PACMAN_BUNDLE_FILE bundle file"
	sudo pacman -S "$(<"$PACMAN_BUNDLE_FILE")" --noconfirm
fi
