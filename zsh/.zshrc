source $HOME/.zsh/history.zsh
source $HOME/.zsh/stack.zsh
source $HOME/.zsh/keys.zsh
source $HOME/.zsh/init.zsh
source $HOME/.zsh/aliases.zsh

source <(antibody init)
antibody bundle < $HOME/.zsh/plugins.txt

# base16 theme
base16_monokai
