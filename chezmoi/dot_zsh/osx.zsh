#!/usr/bin/env zsh

if [[ $(arch) == 'arm64' ]]; then
	# fzf
	source /opt/homebrew/Cellar/fzf/*/shell/completion.zsh
	source /opt/homebrew/Cellar/fzf/*/shell/key-bindings.zsh
	fpath+=("/opt/homebrew/completions/zsh/")
else
	# fzf
	source /usr/local/opt/fzf/shell/completion.zsh
	source /usr/local/opt/fzf/shell/key-bindings.zsh
	fpath+=("/usr/local/Homebrew/completions/")
fi

# completions
FPATH="/opt/homebrew/share/zsh/site-functions:${FPATH}"

if [[ -d /opt/homebrew/share/zsh/site-functions ]]; then
  ZSH_SITE_FUNCTIONS=/opt/homebrew/share/zsh/site-functions
else
  ZSH_SITE_FUNCTIONS=/usr/local/share/zsh/site-functions
fi


if (( $+commands[ggrep] )); then
    alias ggrep='ggrep --color=auto'
fi
