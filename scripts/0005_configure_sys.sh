#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
. "$DIR/buildcheck.sh"

if [[ "$OSTYPE" == "darwin"* ]]; then
	source "$DIR/0009_set_osx_defaults.sh"
else
	source "$DIR/scripts/0010_set_archlinux_defaults.sh"
fi
