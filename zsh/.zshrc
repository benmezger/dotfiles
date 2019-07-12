export GITLINE_NO_TRACKED_UPSTREAM='upstream ${red}!${reset}'

source <(/usr/local/bin/antibody init)
antibody bundle < $HOME/.zsh/plugins.txt

source $HOME/.zsh/init.zsh

source $HOME/.zsh/history.zsh
source $HOME/.zsh/stack.zsh
source $HOME/.zsh/keys.zsh
source $HOME/.zsh/aliases.zsh
source $HOME/.zsh/gpg-agent.zsh

# base16 theme
base16_gruvbox-dark-hard
