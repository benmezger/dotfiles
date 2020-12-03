#!/usr/bin/env bash
set -euo pipefail

echo "SSH file chmod..."
chmod 600 $HOME/.ssh/id_rsa
chmod 600 $HOME/.ssh/id_rsa.pub 
chmod 755 $HOME/.ssh
