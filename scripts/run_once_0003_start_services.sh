#!/usr/bin/env bash
set -euo pipefail

if [[ "$OSTYPE" == "darwin"* ]]; then
    TMUX_PLIST=$HOME/Library/LaunchAgents/com.tmux.plist
    if [ -f "$TMUX_PLIST" ]; then
        echo "Loading tmux.plist..."
        launchctl load -w "$TMUX_PLIST"
    else
        echo "Skipping launchctl of tmux.plist"
    fi

    SYNCMAIL_PLIST="$HOME/Library/LaunchAgents/com.syncmail.plist"
    if [ -f "$SYNCMAIL_PLIST" ]; then
        echo "Loading syncmail.plist..."
        launchctl load -w "$SYNCMAIL_PLIST"
    else
        echo "Skipping launchctl of syncmail.plist"
    fi

elif [[ "$OSTYPE" == "linux-gnu"* ]]; then

    echo "Updating pacman.conf.."
    sudo sed -i '/Color$/s/^#//g' /etc/pacman.conf
    sudo sed -i '/TotalDownload$/s/^#//g' /etc/pacman.conf
    sudo sed -i '/CheckSpace$/s/^#//g' /etc/pacman.conf
    sudo sed -i '/VerbosePkgLists$/s/^#//g' /etc/pacman.conf

    sudo systemctl enable pcscd

    mkdir -p "$HOME/.config/systemd/user/"

    if [ -f "$HOME/.config/systemd/user/greenclip.service" ]; then
        systemctl --user enable greenclip.services
    fi

    if [ -f "$HOME/.config/systemd/user/mbsync.service" ]; then
        systemctl --user enable mbsync.services
        systemctl --user enable mbsync.timer
    fi

fi
