#!/usr/bin/env bash
set -euo pipefail

# dir should be lowercase so we don't conflict with
# script defined DIR variable
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
. "$dir/ansi"

minimal=$(chezmoi data | grep -ci '"minimal": true')

if ! [[ $minimal ]]; then
	ansi --yellow "Skipping post_install due to minimal version"
	exit 0
fi
