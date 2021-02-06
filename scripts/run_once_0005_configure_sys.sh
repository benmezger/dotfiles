#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="${SOURCE_DIR:-$(dirname $(pwd))}"
. "$SOURCE_DIR"/scripts/buildcheck.sh 


if [[ "$OSTYPE" == "darwin"* ]]; then
    # from: https://github.com/mathiasbynens/dotfiles/blob/main/.macos

    defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
    defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

    defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
    defaults write com.apple.LaunchServices LSQuarantine -bool false

    defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

    defaults write NSGlobalDomain KeyRepeat -int 1
    defaults write NSGlobalDomain InitialKeyRepeat -int 10

elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Updating pacman.conf.."
    sudo sed -i '/Color$/s/^#//g' /etc/pacman.conf
    sudo sed -i '/TotalDownload$/s/^#//g' /etc/pacman.conf
    sudo sed -i '/CheckSpace$/s/^#//g' /etc/pacman.conf
    sudo sed -i '/VerbosePkgLists$/s/^#//g' /etc/pacman.conf
fi
