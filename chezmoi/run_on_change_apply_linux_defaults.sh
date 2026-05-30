#!/usr/bin/env bash

if [[ "$(uname)" != "Linux" ]]; then
    exit 0
fi

# Sets sane Linux defaults

isavailable() {
    type "$1" &>/dev/null
}

# enforce dark-mode system-wide
isavailable gsettings && gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"

# set sysctl defaults
sudo tee /etc/sysctl.d/99-desktop.conf << 'EOF'
# Allow dmesg without sudo
kernel.dmesg_restrict = 0

# Improve responsiveness under memory pressure
vm.swappiness = 10
vm.dirty_ratio = 10
vm.dirty_background_ratio = 5

# Better network performance
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_fastopen = 3

# Restrict ptrace to parent processes (security)
kernel.yama.ptrace_scope = 1

# Increase inotify limits (helpful for IDEs, file watchers, Emacs)
fs.inotify.max_user_watches = 524288
fs.inotify.max_user_instances = 512
EOF
