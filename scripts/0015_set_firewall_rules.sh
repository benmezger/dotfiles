#!/usr/bin/env bash
set -euo pipefail

DIR=$(dirname "$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)")
. "$DIR/base.sh"
. "$DIR/ansi"

if [[ "$OSTYPE" != "linux-gnu"* ]]; then
	ansi --yellow "Platform is not linux-gnu"
fi

# ask sudo upfront
sudo -v

ansi --green "Setting UFW defaults"
sudo ufw default deny
sudo ufw allow from 192.168.0.0/24
sudo ufw limit ssh
