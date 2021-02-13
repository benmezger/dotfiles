#!/usr/bin/env bash
set -euo pipefail

# Test if $1 is available
isavailable() {
	type "$1" &>/dev/null
}

LOGFILE="/tmp/dotfiles.log"

echo "Running '$0' $(date)" | tee -a $LOGFILE

echo "Installing required dependencies" | tee -a $LOGFILE
if [[ "$OSTYPE" == "darwin"* ]]; then
	make homebrew-install | tee -a $LOGFILE
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
	isavailable chezmoi || (sudo pacman -S chezmoi --noconfirm | tee -a $LOGFILE)
fi

make all
