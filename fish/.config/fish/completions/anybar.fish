set -l styles white red orange yellow green cyan blue purple black question exclamation

for style in $styles
  echo "entry: $style"
  complete -xc anybar -n "__fish_use_subcommand" -a "$style" -d "Set the Anybar dot to the $style style"
end
