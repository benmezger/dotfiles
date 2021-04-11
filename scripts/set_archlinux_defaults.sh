#!/usr/bin/env bash
set -euo pipefail

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
. "$DIR/base.sh"
. "$DIR/ansi"

if [[ "$OSTYPE" != "linux-gnu"* ]]; then
	ansi --yellow "Platform is not linux-gnu"
fi

if [ ! -f "/etc/arch-release" ]; then
	ansi --yellow "Not running arch. Skipping."
fi

# ask sudo upfront
sudo -v

ansi --green "Updating pacman.conf.."
sudo sed -i '/Color$/s/^#//g' /etc/pacman.conf
sudo sed -i '/TotalDownload$/s/^#//g' /etc/pacman.conf
sudo sed -i '/CheckSpace$/s/^#//g' /etc/pacman.conf
sudo sed -i '/VerbosePkgLists$/s/^#//g' /etc/pacman.conf

ansi --green "Enable timedatectl and set up timezone"
sudo timedatectl set-timezone America/Sao_Paulo
sudo timedatectl set-ntp 1
sudo timedatectl set-local-rtc 0
sudo ln -sf /usr/share/zoneinfo/Ameriaca/Sao_Paulo /etc/localtime

ansi --green "Setup locale"
sudo sed -i '/en_US.UTF-8$/s/^#//g' /etc/pacman.conf
sudo locale-gen
