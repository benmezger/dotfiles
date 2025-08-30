#!/usr/bin/env sh

echo "Fixing GnuPG permissions"
chown -R "$USER" ~/.gnupg/
chmod 700 ~/.gnupg/*
chmod 700 ~/.gnupg

echo "Refreshing GPG keys"
gpg --refresh-keys

chmod 755 "$HOME/.ssh"
[ -f "$HOME/.ssh/id_ed25519" ] && chmod 600 "$HOME/.ssh/id_ed25519"
[ -f "$HOME/.ssh/id_ed25519.pub" ] && chmod 600 "$HOME/.ssh/id_ed25519.pub"

echo "Updating doom modules"
doom sync -e
