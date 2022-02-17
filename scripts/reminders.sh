#!/usr/bin/env bash

DIR=$(dirname "$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)")
. "$DIR/scripts/buildcheck.sh"
. "$DIR/scripts/base.sh"
. "$DIR/scripts/ansi"

ansi --yellow "######################################################################"
ansi --yellow "######################################################################"
ansi --yellow "######################################################################"

ansi --white "######### Powertop ##########"
ansi --green "Rembember to run 'powertop --calibrate'"
ansi --green "See https://wiki.archlinux.org/title/Powertop for more information"
