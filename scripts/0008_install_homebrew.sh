#!/usr/bin/env bash
set -euo pipefail

# Test if $1 is available
isavailable() {
    type "$1" &>/dev/null
}

if [[ "$OSTYPE" == "darwin"* ]]; then
    isavailable brew || \
        curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh
    isavailable chezmoi || brew install chezmoi
else
	echo "Not a darwin platform. Skipping"
fi
