#!/usr/bin/env zsh

# fzf
source /usr/share/fzf/completion.zsh

# wakatime
export ZSH_WAKATIME_BIN="/usr/bin/wakatime"

# docker
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock

# gdb
export DEBUGINFOD_URLS="https://debuginfod.elfutils.org"

# dbus
export $(dbus-launch)

# dpi
# export GDK_SCALE=2
