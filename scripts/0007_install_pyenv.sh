#!/usr/bin/env bash
set -euo pipefail

PYENV_DIR="$HOME/.pyenv"
if [ ! -d "$PYENV_DIR" ]; then
    curl https://pyenv.run | bash
fi
