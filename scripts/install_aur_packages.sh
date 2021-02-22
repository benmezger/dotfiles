#!/usr/bin/env bash
set -euo pipefail

DIR=$(dirname "$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)")
. "$DIR/scripts/buildcheck.sh"
. "$DIR/scripts/base.sh"
. "$DIR/scripts/ansi"

if [[ "$OSTYPE" != "linux-gnu"* ]]; then
	ansi --yellow "Not a Linux platform. Skipping."
	exit 0
fi

if [ ! -f "/etc/arch-release" ]; then
	ansi --yellow "Not running arch. Skipping."
fi

if ! isavailable paru; then
	ansi --yellow "Paru not available. Installing."
	PARU_PATH=/tmp/paru

	git clone https://aur.archlinux.org/paru.git $PARU_PATH
	(cd $PARU_PATH && makepkg -si)
fi

AUR_BUNDLE_FILE="$DIR/Aurfile"
ansi --green "Using $AUR_BUNDLE_FILE bundle file"
paru -S --nouseask - <"$AUR_BUNDLE_FILE"
