#!/usr/bin/env bash
set -euo pipefail

# Test if $1 is available
isavailable() {
    type "$1" &>/dev/null
}

echo "Installing required dependencies"
if [[ "$OSTYPE" == "darwin"* ]]; then
    make homebrew-install
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    isavailable chezmoi || sudo pacman -S chezmoi --noconfirm
fi

make all
