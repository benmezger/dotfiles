#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
. "$DIR/base.sh"
. "$DIR/ansi"

ansi --yellow "Ensuring required directories exist.."
mkdir -pv $HOME/workspace/opt
mkdir -pv $HOME/workspace/go

mkdir -pv $HOME/mail/personal
mkdir -pv $HOME/mail/work
mkdir -pv $HOME/mail/.attachments
