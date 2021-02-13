#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
. "$DIR/buildcheck.sh"
. "$DIR/base.sh"
. "$DIR/ansi"

if [[ -d "$HOME/.gnupg" ]]; then
	ansi --green "Changing GnuPG permissions.."

	chown -R $(whoami) ~/.gnupg/
	# Also correct the permissions and access rights on the directory
	chmod 700 ~/.gnupg/*
	chmod 700 ~/.gnupg
fi
