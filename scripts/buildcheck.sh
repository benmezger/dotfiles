#!/usr/bin/env bash
set -euo pipefail

if [ "${CI:-0}" = "1" ]; then
    echo "Skipping post_install due to CI variable set to 1"
    exit 0
fi
