#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
. "$DIR/ansi"

if [[ "$OSTYPE" == "darwin"* ]]; then
	TMUX_PLIST=$HOME/Library/LaunchAgents/com.tmux.plist
	if [ -f "$TMUX_PLIST" ]; then
		ansi --green "Loading tmux.plist..."
		(launchctl list | grep --silent tmux) && launchctl unload "$TMUX_PLIST"
		launchctl load -w "$TMUX_PLIST"
	else
		ansi --yellow "Skipping launchctl of tmux.plist"
	fi

	SYNCMAIL_PLIST="$HOME/Library/LaunchAgents/com.syncmail.plist"
	if [ -f "$SYNCMAIL_PLIST" ]; then
		ansi --green "Loading syncmail.plist..."
		(launchctl list | grep --silent syncmail) && launchctl unload "$SYNCMAIL_PLIST"
		launchctl load -w "$SYNCMAIL_PLIST"
	else
		ansi --yellow "Skipping launchctl of syncmail.plist"
	fi

elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
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
