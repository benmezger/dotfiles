#!/bin/bash

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone https://github.com/Valloric/ycmd.git ~/workspace/git/packages/
(cd ~/workspace/git/packages; git submodule update --init --recursive)
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
git clone https://github.com/chriskempson/base16-shell.git ~/workspace/git/
