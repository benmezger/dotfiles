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
go install github.com/arl/gitmux@latest

ansi --green "Installing gopls.."
GO111MODULE=on go install golang.org/x/tools/gopls@latest

ansi --green "Installing Chezmoi"
go install github.com/twpayne/chezmoi@latest

ansi --green "Install assembly formatter"
go install github.com/klauspost/asmfmt/cmd/asmfmt@latest
