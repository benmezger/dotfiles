#!/usr/bin/env zsh

# homebrew
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_VERBOSE_USING_DOTS=1

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

if [[ -d "/Library/TeX/texbin" ]]; then
	export PATH="$PATH:/Library/TeX/texbin"
fi

if (( $+commands[gcloud] )); then
	source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
	source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"
fi

# completions
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

if [[ -d /opt/homebrew/share/zsh/site-functions ]]; then
  ZSH_SITE_FUNCTIONS=/opt/homebrew/share/zsh/site-functions
else
  ZSH_SITE_FUNCTIONS=/usr/local/share/zsh/site-functions
fi

source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh
source $(pyenv root)/completions/pyenv.zsh

if (( $+commands[ggrep] )); then
    alias ggrep='ggrep --color=auto'
fi
