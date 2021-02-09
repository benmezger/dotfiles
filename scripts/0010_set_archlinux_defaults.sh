#!/usr/bin/env bash
set -euo pipefail

if [[ "$OSTYPE" != "linux-gnu"* ]]; then
	echo "Platform is not linux-gnu"
fi

if [ ! -f "/etc/arch-release" ]; then
	echo "Not running arch. Skipping."
fi

echo "Updating pacman.conf.."
sudo sed -i '/Color$/s/^#//g' /etc/pacman.conf
sudo sed -i '/TotalDownload$/s/^#//g' /etc/pacman.conf
sudo sed -i '/CheckSpace$/s/^#//g' /etc/pacman.conf
sudo sed -i '/VerbosePkgLists$/s/^#//g' /etc/pacman.conf
