#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR=$(chezmoi source-path)
export SOURCE_DIR

LOGFILE="/tmp/dotfiles.log"
echo "Running post install $(date)" | tee -a $LOGFILE

(cd $SOURCE_DIR && make post-chezmoi)
