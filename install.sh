#!/usr/bin/env bash
set -euo pipefail

# Test if $1 is available
isavailable() {
    type "$1" &>/dev/null
}


echo "Installing required dependencies"
if [[ "$OSTYPE" == "darwin"* ]]; then
    isavailable brew || \
        curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh
    isavailable ansible || brew install ansible
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    isavailable ansible || sudo pacman -S ansible
fi

echo "Installing ansible galaxies"
ansible-galaxy install -r requirements.yml


echo "Running ansible playbook for $OSTYPE"
if [[ "$OSTYPE" == "darwin"* ]]; then
    ansible-playbook -i inventory osx.yml -K
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ansible-playbook -i inventory archlinux.yml -K
fi
