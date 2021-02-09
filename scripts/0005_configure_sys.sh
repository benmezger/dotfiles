#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="${SOURCE_DIR:-"$(pwd)"}"

if [[ "$OSTYPE" == "darwin"* ]]; then
	source "$SOURCE_DIR/scripts/0009_set_osx_defaults.sh"
else
	source "$SOURCE_DIR/scripts/0010_set_archlinux_defaults.sh"
fi
