#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR=$(chezmoi source-path)
export SOURCE_DIR

(cd $SOURCE_DIR; make post-chezmoi)
