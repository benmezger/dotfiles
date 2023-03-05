#!/usr/bin/env sh

SOURCE_DIR=$(chezmoi source-path)
export SOURCE_DIR

(cd $SOURCE_DIR && make fix-permissions)
