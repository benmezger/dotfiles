#!/bin/bash
# SPDX-License-Identifier: MIT

## Copyright (C) 2009 Przemyslaw Pawelczyk <przemoc@gmail.com>
##
## This script is licensed under the terms of the MIT license.
## https://opensource.org/licenses/MIT
#
# Lockable script boilerplate

### HEADER ###

LOCKFILE="/tmp/$(basename $0)"
LOCKFD=99

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	flock=/usr/bin/flock
elif [[ "$OSTYPE" == "darwin"* ]]; then
	flock=/usr/local/bin/flock
fi

# PRIVATE
_lock() { $flock -$1 $LOCKFD; }
_no_more_locking() {
	_lock u
	_lock xn && rm -f $LOCKFILE
}
_prepare_locking() {
	eval "exec $LOCKFD>\"$LOCKFILE\""
	trap _no_more_locking EXIT
}

# ON START
_prepare_locking

# PUBLIC
exlock_now() { _lock xn; } # obtain an exclusive lock immediately or fail
exlock() { _lock x; }      # obtain an exclusive lock
shlock() { _lock s; }      # obtain a shared lock
unlock() { _lock u; }      # drop a lock
