#!/usr/bin/env zsh

ZSH_SITE_FUNCTIONS=/usr/share/zsh/site-functions

source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh

# docker
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock

# gdb
export DEBUGINFOD_URLS="https://debuginfod.elfutils.org"

# dpi
# export GDK_SCALE=2

# alacritty
export VBLANK_MODE=1

export SSH_AUTH_SOCK="$HOME/.1password/agent.sock"

# smooth scrolling on firefox
export MOZ_USE_XINPUT2=1

# tmux: disable autostart when running under dwm
if pgrep -x dwm > /dev/null; then
	export IS_DWM=1
fi
