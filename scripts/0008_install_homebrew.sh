#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
. "$DIR/base.sh"
. "$DIR/ansi"

if [[ "$OSTYPE" == "darwin"* ]]; then
	isavailable brew ||
		curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh
	isavailable chezmoi || brew install chezmoi
else
	ansi --yellow "Not a darwin platform. Skipping"
fi
