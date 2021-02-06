#!/usr/bin/env bash
set -euo pipefail

# Test if $1 is available
isavailable() {
    type "$1" &>/dev/null
}

if ! [ -x "$(command -v chezmoi)" ]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        isavailable brew || curl -sfL https://git.io/chezmoi | sh
        isavailable brew && brew install chezmoi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        isavailable chezmoi || sudo pacman -S chezmoi --noconfirm
    fi
else
    echo "Chezmoi exists, skipping."
fi
