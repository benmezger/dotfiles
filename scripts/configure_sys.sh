#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
. "$DIR/base.sh"

if [[ "$OSTYPE" == "darwin"* ]]; then
	source "$DIR/set_osx_defaults.sh"
else
	source "$DIR/set_archlinux_defaults.sh"
fi
