#!/usr/bin/env zsh

# homebrew
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_VERBOSE_USING_DOTS=1

export PATH="$PATH:/run/current-system/sw/bin/"

if [[ $(arch) == 'arm64' ]]; then
	export PATH="/opt/homebrew/bin:$PATH"
	export PATH="/opt/homebrew/opt:$PATH"
	# fzf
	source /opt/homebrew/Cellar/fzf/*/shell/completion.zsh
	source /opt/homebrew/Cellar/fzf/*/shell/key-bindings.zsh

	if [[ -d "/opt/homebrew/opt/gnupg@2.2" ]]; then
		export PATH="$PATH:/opt/homebrew/opt/gnupg@2.2/bin"
	fi

	fpath+=("/opt/homebrew/completions/zsh/")
else
	# fzf
	source /usr/local/opt/fzf/shell/completion.zsh
	source /usr/local/opt/fzf/shell/key-bindings.zsh
	fpath+=("/usr/local/Homebrew/completions/")
fi

export ZSH_WAKATIME_BIN=wakatime-cli

if [[ -d "/Library/TeX/texbin" ]]; then
	export PATH="$PATH:/Library/TeX/texbin"
fi

if (( $+commands[gcloud] )); then
	source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
	source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"
fi

# completions
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh
source $(pyenv root)/completions/pyenv.zsh
