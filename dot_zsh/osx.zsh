#!/usr/bin/env zsh

# homebrew
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_VERBOSE_USING_DOTS=1

# fzf
source /usr/local/opt/fzf/shell/key-bindings.zsh
source /usr/local/opt/fzf/shell/completion.zsh

if [[ -d "/Library/TeX/texbin" ]]; then
	export PATH="$PATH:/Library/TeX/texbin"
fi

export ZSH_WAKATIME_BIN="/usr/local/bin/wakatime-cli"
