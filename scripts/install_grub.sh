#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
. "$DIR/base.sh"
. "$DIR/minimalcheck.sh"
. "$DIR/ansi"

THEME="arch"
THEME_DIR="$HOME/workspace/distro-grub-themes"
GRUB_THEME_DIR="/boot/grub/themes"

if ! [ -x "$(command -v grub-install)" ]; then
	ansi --red 'Error: grub is not installed.'
	exit 1
fi

if [ ! -d "$THEME_DIR" ]; then
	git clone https://github.com/AdisonCavani/distro-grub-themes.git $THEME_DIR
fi

sudo -v

if [ ! -f "$GRUB_THEME_DIR" ]; then
	sudo mkdir -pv $GRUB_THEME_DIR
fi

sudo cp -vrf $THEME_DIR/customize/$THEME $GRUB_THEME_DIR
sudo sed -i -e '/^GRUB_THEME=/s/=.*/="'$THEME'"/' /etc/default/grub

ansi --yellow "#################################################################"
ansi --yellow "#################################################################"
ansi --yellow "Make sure you check /etc/default/grub before running grub-install"
ansi --yellow "#################################################################"
ansi --yellow "#################################################################"
