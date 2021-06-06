#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
. "$DIR/base.sh"
. "$DIR/minimalcheck.sh"
. "$DIR/ansi"

if ! isavailable go; then
	ansi --yellow "Go not installed. Skipping"
	exit 0
fi

ansi --green "Installing gitmux.."
go get -u github.com/arl/gitmux

ansi --green "Installing gopls.."
GO111MODULE=on go get golang.org/x/tools/gopls@latest

ansi --green "Installing Chezmoi"
go install github.com/twpayne/chezmoi@latest
