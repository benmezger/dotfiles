#!/usr/bin/env zsh

ZSH_SITE_FUNCTIONS=/usr/share/zsh/site-functions

source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh

# dpi
# export GDK_SCALE=2

# alacritty
export VBLANK_MODE=1

# smooth scrolling on firefox
export MOZ_USE_XINPUT2=1

# tmux: disable autostart when running under dwm
if pgrep -x dwm > /dev/null; then
	export IS_DWM=1
fi
