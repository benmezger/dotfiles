#!/bin/bash
#
#   Copyright 2018 Carl Anderson
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
#   Modified by Nick Bradley


# Prevent errors from sourcing this file mor than once.
[[ -n "${ASH_SESSION_ID}" ]] && return

# Make sure we are running the shell we think we are running.
if ! ps ho command $$ | grep -q "zsh"; then
  echo "The shell process name implies you're not running zsh..."
  return
fi

export ASH_SESSION_ID="$( __ash_generate_session_id )"

# Keep track of working directory before a command executes
cmd_cwd="${PWD}"

#
# Necessary zsh history settings that allow history collection to work:
#
setopt extended_history  # Adds start timestamp to log file
setopt inc_append_history  # Forces log file to be appended after each command.
(( SAVEHIST < 1 )) && export SAVEHIST=1  # SAVEHIST must be > 0

##
# Invoked by __ash_log in the common library (see parent directory).
#
function __ash_last_command() {
  # Prevent users from manually invoking this function from the command line.
  [[ "${ASH:-0}" == "0" ]] && __ash_info __ash_last_command && return

  local cmd cmd_no start_ts end_ts=$( date +%s )
  read start_ts <<< "$( grep "^:" "${HISTFILE}" | tail -n1 | cut -d: -f2 )"
  read -r cmd_no cmd <<< "$( builtin history -1 )"
  echo -E ${cmd_no:-0} ${start_ts:-0} ${end_ts:-0} "${cmd:-UNKNOWN}"
}


##
# Placeholder function.
#
function __ash_original_precmd() {
  # Prevent users from manually invoking this function from the command line.
  [[ "${ASH:-0}" == "0" ]] && __ash_info __ash_original_precmd && return
}

# This takes the definition of the original precmd (if one was defined) and
# renames it to __ash_original_precmd (overwriting the placeholder above).
source <( typeset -f precmd | sed -e 's/^precmd/__ash_original_precmd/' )

##
# Invoked before each new prompt is written, and after the previous command
# has finished.
#
function precmd() {
    local rval=$?
    local cmd=($(ASH=1 __ash_last_command))
    local duration=$((${cmd[3]}-${cmd[2]}))
    aw_post_event ${duration} ${cmd[1]} ${rval} "${cmd_cwd}" "${cmd[@]:3}"
    ASH=1 __ash_original_precmd
    cmd_cwd="${PWD}"
    return rval
}
