#!/usr/bin/env bash
set -euo pipefail

# dir should be lowercase so we don't conflict with
# script defined DIR variable
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
. "$dir/ansi"

if [ "${CI:-0}" = "1" ]; then
	ansi --red "Skipping post_install due to CI variable set to 1"
	exit 0
fi
