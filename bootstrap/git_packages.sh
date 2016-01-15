#!/bin/bash

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone https://github.com/Valloric/ycmd.git ~/Workspace/git/packages/
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
git clone https://github.com/baskerville/sxhkd.git ~/Workspace/git/packages/
