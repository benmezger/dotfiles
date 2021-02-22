#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
. "$DIR/buildcheck.sh"
. "$DIR/base.sh"
. "$DIR/ansi"

RISCV_PATH="$HOME/workspace/opt/riscv64gc/"
RISCV_REPO=$(dirname $(dirname "$RISCV_PATH")) # $HOME/workspace/
CONF_FLAGS="--prefix=$RISCV_PATH --with-arch=rv64gc"

if [ ! -d "$RISCV_REPO" ]; then
	mkdir -pv "$RISCV_REPO"
	ansi --green "Cloning RISC-V toolchain.."
	git clone https://github.com/riscv/riscv-gnu-toolchain \
		"$RISCV_REPO" --recursive -j8
else
	ansi --yellow "RISC-V repository exists. Skipping."
fi

if [ ! -d "$RISCV_PATH" ]; then
	ansi --green "Buidling RISC-V toolchain.."
	cd $RISCV_REPO
	./configure $CONF_FLAGS
	make install
else
	ansi --yellow "RISC-V toolchain exists. Skipping."
fi
