#!/bin/zsh
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

# Ensure there is a HISTFILE.
if [[ -z "${HISTFILE}" ]]; then
  export HISTFILE="${HOME}/.awshell_history"
  echo  "aw-watcher-shell WARN: HISTFILE undefined. Exporting HISTFILE as: '${HISTFILE}'."
fi
if [[ ! -e "${HISTFILE}" ]] && ! touch "${HISTFILE}" &>/dev/null; then
  echo "aw-watcher-shell ERROR: Failed to create shell history file: '${HISTFILE}'."
fi
if ! chmod u+rw "${HISTFILE}" &>/dev/null; then
  echo "aw-watcher-shell ERROR: Failed to make shell history file readable and writeable."
fi

##
# Displays a message to users who manually invoked an internal-only shell
# function.  This is to prevent curious users from messing up internal state
# accidentally.
#
# Internally, this function is used within protected functions like this:
#   function __ash_example() {
#     [[ "${ASH:-0}" == "0" ]] && __ash_info __ash_example && return
#     # Protected function code here...
#   }
#
function __ash_info() {
  cat << EOF_INFO
${@:-This} is an internal function of the aw-watcher-shell tracker.
EOF_INFO
}

export ASH_SKIP=0


function __ash_generate_session_id() {
    od -x /dev/urandom | head -1 | awk '{OFS="-"; srand($6); sub(/./,"4",$5); sub(/./,substr("89ab",rand()*4,1),$6); print $2$3,$4,$5,$6,$7$8$9}'
}

function aw_ensure_bucket() {
    res=$(curl \
        --silent \
        --fail \
        --output /dev/null \
        --write-out "%{http_code}" \
        --data '{"type":"shell.command","client":"aw-watcher-shell","hostname":'\"`hostname`\"'}' \
        --header "Content-Type: application/json" \
        --request POST "localhost:5600/api/0/buckets/aw-watcher-shell_`hostname`")

    if [ "$res" -ne "200" -a "$res" -ne "304"  ]; then
        echo "aw-watcher-shell WARN: Unable to connect to ActivityWatch server at http://localhost:5600. This session will not be recorded.";
    fi
}

##
#
# Params:
# - duration
# - command number
# - exit status code
# - command string
#
function aw_post_event() {
    local duration=${1:-0}
    local cmd_no=${2:-0}
    local code=${3:-1}
    local cwd="${4}"
    local cmd_raw="${@:5}"
    # escape any double quotes
    local cmd="${cmd_raw//\"/\\\"}"
    event_fmt='{"duration":%d,"data":{"cmdNo":%d,"session":"%s","cmdStr":"%s","code":%d, "cwd":"%s"}}'
    # printf "$event_fmt" ${duration} ${cmd_no} ${ASH_SESSION_ID} "${cmd}" ${code} "${cwd}"
    res=$(curl \
        --silent \
        --fail \
        --output /dev/null \
        --write-out "%{http_code}" \
        --data "$(printf "$event_fmt" ${duration} ${cmd_no} ${ASH_SESSION_ID} "${cmd}" ${code} "${cwd}")" \
        --header "Content-Type: application/json" \
        --request POST "localhost:5600/api/0/buckets/aw-watcher-shell_`hostname`/events")

    if [ "$AWSH_DEBUG" -a "$res" -ne "200" ]; then
        echo "aw-watcher-shell ERROR: Failed to POST event $(printf "$event_fmt" ${duration} ${cmd_no} "${cmd}" ${code} "${cwd}"); Status $res."
    fi
}

if ps ho command $$ | grep -q "zsh"; then
  script_dir="`cd "$( dirname "${(%):-%x}" )" > /dev/null 2>&1 && pwd`"
  aw_ensure_bucket
  source "${script_dir}/aw-watcher.zsh"
elif ps ho command $$ | grep -q "bash"; then
  script_dir="`cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null 2>&1 && pwd`"
  aw_ensure_bucket
  source "${script_dir}/aw-watcher.bash"
else
    echo "aw-watcher-shell only works in bash and zsh shells."
    return
fi
