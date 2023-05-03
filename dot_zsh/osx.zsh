#!/usr/bin/env zsh

# homebrew
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_VERBOSE_USING_DOTS=1

if [[ $(arch) == 'arm64' ]]; then
	export PATH="$PATH:/opt/homebrew/bin"
	# fzf
	source /opt/homebrew/Cellar/fzf/*/shell/completion.zsh
	source /opt/homebrew/Cellar/fzf/*/shell/key-bindings.zsh
else
	# fzf
	source /usr/local/opt/fzf/shell/completion.zsh
	source /usr/local/opt/fzf/shell/key-bindings.zsh
fi

export ZSH_WAKATIME_BIN=wakatime-cli

if [[ -d "/Library/TeX/texbin" ]]; then
	export PATH="$PATH:/Library/TeX/texbin"
fi

if (( $+commands[gcloud] )); then
	source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
fi

# completions
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
