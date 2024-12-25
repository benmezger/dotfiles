#!/usr/bin/env zsh

export PATH="$PATH:$HOME/.nix-profile/bin/:/run/current-system/sw/bin/"

if (( $+commands[nix-env] )); then
	export PATH="/run/wrappers/bin/:$PATH:/bin"
	source $HOME/.nix-profile/share/fzf/completion.zsh
	source $HOME/.nix-profile/share/fzf/key-bindings.zsh

	export ZSH_WAKATIME_BIN="$HOME/.nix-profile/bin/wakatime-cli"

	source $HOME/.nix-profile/share/antidote/antidote.zsh
else
	source /usr/share/fzf/completion.zsh
	source /usr/share/fzf/key-bindings.zsh

	export ZSH_WAKATIME_BIN="/usr/bin/wakatime"

	source /usr/share/zsh-antidote/antidote.zsh
fi

# docker
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock

# gdb
export DEBUGINFOD_URLS="https://debuginfod.elfutils.org"

# dpi
# export GDK_SCALE=2

# alacritty
export VBLANK_MODE=1

export SSH_AUTH_SOCK="$HOME/.1password/agent.sock"

