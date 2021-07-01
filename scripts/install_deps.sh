#!/usr/bin/env bash
set -euo pipefail

DIR=$(dirname "$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)")
. "$DIR/scripts/base.sh"
. "$DIR/scripts/ansi"

export HOMEBREW_BUNDLE_FILE="$DIR/Brewfile"
PACMAN_BUNDLE_FILE="$DIR/Pacfile"

if [[ "$OSTYPE" == "darwin"* ]]; then
	ansi --green "Using $HOMEBREW_BUNDLE_FILE bundle file"

	brew bundle

	ansi --green "Installing Mute Me app"
	curl https://github.com/pixel-point/mute-me/releases/download/v2.0.0-rc2/mute-me-v2.0.0-rc2.zip \
		-L -o /tmp/muteme.zip

	unzip -o /tmp/muteme.zip -d /tmp/
	rm -rf "$HOME/Applications/Mute Me.app/"
	mv "/tmp/Mute Me.app" "$HOME/Applications"

	ansi --green "Installing Itsycal"
	curl https://itsycal.s3.amazonaws.com/Itsycal.zip \
		-L -o /tmp/itsycal.zip

	unzip -o /tmp/itsycal.zip -d /tmp/
	rm -rf "$HOME/Applications/Itsycal.app/"
	mv "/tmp/Itsycal.app" "$HOME/Applications"


elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
	# ask sudo upfront
	sudo -v
	sudo pacman -Syy
	ansi --green "Using $PACMAN_BUNDLE_FILE bundle file"
	sudo pacman -S --noconfirm --needed - <"$PACMAN_BUNDLE_FILE"
fi
