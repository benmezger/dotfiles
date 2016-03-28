#!/bin/bash

set -e # exit if any non zero return code

echo "Copying ca-certificates to $HOME/.certs"
if [ ! -d "$HOME/.certs" ]; then
    mkdir $HOME/.certs
fi

ln -fs $(pwd)/ca-certificates.crt $HOME/.certs/ca-certificates.crt

function do_brew {
    if [ ! hash brew 2>/dev/null ]; then
        echo "Installing homebrew"
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    echo "Installing OSX packages"
    sh brewit.sh

    echo "Installing system python packages"
    pip install --upgrade pip setuptools
    pip install virtualenvwrapper
}

function do_python {
    # if running any virtualenv, deactivate it.
    : ${VIRTUAL_ENV}? deactivate
    echo "Configuring virtualenvwrapper..."

    ENVW=$(which virtualenvwrapper.sh)
    export WORKON_HOME=$HOME/.virtualenvs
    export PROJECT_HOME=$HOME/workspace
    source $ENVW

    mkvirtualenv pyenv
    workon pyenv
    pip install --upgrade pip setuptools
    pip install -r requirements.txt
}

function do_rvm {
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3

    \curl -o /tmp/rvm-installer -O https://raw.githubusercontent.com/rvm/rvm/master/binscripts/rvm-installer
    \curl -o /tmp/rvm-installer.asc -O https://raw.githubusercontent.com/rvm/rvm/master/binscripts/rvm-installer.asc

    gpg --verify /tmp/rvm-installer.asc /tmp/rvm-installer
    rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi

    bash rvm-installer stable
    rehash
    rvm install ruby ruby-2.2.1
}

function do_git {
    echo "Installing git packages"
    if [ ! -d "$HOME/workspace" ]; then
        mkdir -p $HOME/workspace/git
    elif [ ! -d "$HOME/workspace/git" ]; then
        mkdir $HOME/workspace/git
    fi

    sh git_packages.sh

    echo "Configuring YCMD"
    (cd $HOME/workspace/git/ycmd/; git submodule update --init --recursive; ./build.py --clang-completer --omnisharp-completer --system-libclang)
    echo "Done git"
}

function do_zsh {
    if [ ! -d "$HOME/.zprezto" ]; then
        git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
        PRETZO="""setopt EXTENDED_GLOB
        for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
            ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
        done"""
        zsh $PREZTO
    fi
    chsh -s /bin/zsh 
}

function do_mackup {
    cp -r ../.mackup* $HOME
    mackup restore
}

function do_others {
    sh osx.sh	
}

# do it!
do_brew
do_python
do_git
do_zsh
do_mackup
do_rvm
