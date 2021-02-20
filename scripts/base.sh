#!/usr/bin/env bash
set -euo pipefail

# Test if $1 is available
isavailable() {
	type "$1" &>/dev/null
}

export TERM=xterm-256color

# from: https://stackoverflow.com/a/21320645
function red_stderr() {
	export COLOR_RED="$(tput setaf 1)"
	export COLOR_RESET="$(tput sgr0)"

	exec 9>&2
	exec 8> >(perl -e '$|=1; while(sysread STDIN,$a,9999) {print "$ENV{COLOR_RED}$a$ENV{COLOR_RESET}"}')
	function undirect() { exec 2>&9; }
	function redirect() { exec 2>&8; }
	trap "redirect;" DEBUG
	PROMPT_COMMAND='undirect;'
}

red_stderr
