#!/usr/bin/env bash
set -euo pipefail

. buildcheck.sh 

if ! [ -x "$(command -v chezmoi)" ]; then
    curl -sfL https://git.io/chezmoi | sh
else
    echo "Chezmoi exists, skipping."
fi
