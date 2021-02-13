#!/usr/bin/env bash
set -euo pipefail

# Test if $1 is available
isavailable() {
	type "$1" &>/dev/null
}

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
. "$DIR/ansi"

if ! [ -x "$(command -v chezmoi)" ]; then
	if [[ "$OSTYPE" == "darwin"* ]]; then
		isavailable brew || curl -sfL https://git.io/chezmoi | sh
		isavailable brew && brew install chezmoi
	elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
		isavailable chezmoi || sudo pacman -S chezmoi --noconfirm
	fi
else
	ansi --yellow "Chezmoi exists, skipping."
fi
