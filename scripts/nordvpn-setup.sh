#!/usr/bin/env bash

set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
. "$DIR/base.sh"
. "$DIR/minimalcheck.sh"

if [[ "$OSTYPE" != "linux-gnu"* ]]; then
	ansi --yellow "Platform is not linux-gnu"
fi

nordvpn set technology nordlynx
nordvpn set cybersec enabled
nordvpn set autoconnect enabled
nordvpn set firewall on
nordvpn set killswitch on
nordvpn whitelist add port 22
nordvpn whitelist add subnet 192.168.0.1/24
nordvpn whitelist add subnet 192.168.0.0/1
