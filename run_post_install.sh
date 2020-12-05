#!/usr/bin/env bash
set -euo pipefail

if [ "${CI:-0}" = "1" ]; then
    echo "Skipping post_install due to CI variable set to 1"
    exit 0
fi

if [[ -d "$HOME/.ssh" ]]; then
        echo "SSH file chmod..."

        chmod 755 $HOME/.ssh
        [[ -f $HOME/.ssh/id_rsa ]] && chmod 600 $HOME/.ssh/id_rsa
        [[ -f $HOME/.ssh/id_rsa.pub ]] && chmod 600 $HOME/.ssh/id_rsa.pub 
fi

echo "Done"
