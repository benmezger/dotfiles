#!/bin/bash

echo "Copying etc files to /etc"
sudo cp -rfv etc/* /etc/
echo "Done copying files"

ln -s `pwd`/ca-certificates.crt ~/.ssh/

# install packages
function do_aptget {
    package_file="package_file"
    while read -r line
    do
	sudo apt-get install $line
    done < "$package_file"
}

# configure python
function do_python {
    # python
    echo "Configuring Python virtualenv"
    sudo pip2 install virtualenvwrapper
    ENVW=$(which virtualenvwrapper.sh)
    export WORKON_HOME=$HOME/.virtualenvs
    export PROJECT_HOME=$HOME/Workspace
    source $ENVW
    mkvirtualenv pyenv
    workon pyenv
    pip install --upgrade pip setuptools
    pip install -r requirements.txt
    echo "Done python"
}

function do_git {
    echo "Installing git stuff"
    if [ ! -d "$HOME/Workspace" ]; then
	mkdir -p $HOME/Workspace/git
    elif [ ! -d "$HOME/Workspace/git" ]; then
	mkdir $HOME/Workspace/git
    fi
    sh git_packages.sh
    echo "configuring YCMD"
    (cd $HOME/Workspace/git/ycmd/; git submodule update --init --recursive; ./build --clang-completer --gocode-completer)
    echo "Done git"
}

function do_zsh {
    chsh -s /usr/bin/zsh
    PREZTO="setopt EXTENDED_GLOB
	for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
		  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
	  done"
    zsh $PREZTO
    echo "Done zsh."
}

do_aptget
do_python
do_git
do_zsh

MACKUP_BIN="$HOME/.virtualenvs/pyenv/bin/mackup"
cp -r ../.mackup* ~/
$MACKUP_BIN restore
