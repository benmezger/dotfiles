#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="${SOURCE_DIR:-$(dirname `pwd`)}"

export HOMEBREW_BUNDLE_FILE="$SOURCE_DIR/Brewfile"
PACMAN_BUNDLE_FILE="$SOURCE_DIR/Pacfile"


if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Using $HOMEBREW_BUNDLE_FILE bundle file"
    brew bundle
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo pacman -S $(< $PACMAN_BUNDLE_FILE) --noconfirm
fi
