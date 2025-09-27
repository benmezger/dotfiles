#!/usr/bin/env zsh

source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh
source /usr/share/zsh-antidote/antidote.zsh
source $(pyenv root)/completions/pyenv.zsh

# docker
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock

# gdb
export DEBUGINFOD_URLS="https://debuginfod.elfutils.org"

# dpi
# export GDK_SCALE=2

# alacritty
export VBLANK_MODE=1

export SSH_AUTH_SOCK="$HOME/.1password/agent.sock"
