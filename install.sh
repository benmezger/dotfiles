#!/usr/bin/env bash
set -euo pipefail

# Test if $1 is available
isavailable() {
	type "$1" &>/dev/null
}

LOGFILE="/tmp/dotfiles.log"

echo "Running '$0' $(date)" | tee -a $LOGFILE
make all
