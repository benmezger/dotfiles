#!/bin/bash
input=$(cat)
model=$(jq -r '.model.display_name' <<<"$input")
dir=$(jq -r '.workspace.current_dir' <<<"$input")
cfg="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"

if jq -e . "$cfg/settings.json" >/dev/null 2>&1; then
  profile=$(basename "$cfg")
  if [ -n "$ANTHROPIC_BASE_URL" ] || jq -e '.apiKeyHelper' "$cfg/settings.json" >/dev/null 2>&1; then
    auth="azure"
  else
    auth="default"
  fi
else
  profile="BAD-JSON"; auth="?"
fi

echo "[$model] ${dir##*/} | cfg:$profile auth:$auth"
