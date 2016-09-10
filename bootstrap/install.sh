#!/bin/bash

# install packages
function pacman {
    package_file="package_file"
    while read -r line; do
	    sudo pacman -S "$line"
    done < "$package_file"
}

# configure python
function do_python {
    # python
    echo "Configuring Python virtualenv"
    sudo pip2 install virtualenvwrapper
    ENVW=$(which virtualenvwrapper.sh)
    export WORKON_HOME=$HOME/.virtualenvs
    export PROJECT_HOME=$HOME/workspace
    source $ENVW

    mkvirtualenv pyenv
    workon pyenv
    pip install --upgrade pip setuptools
    pip install -r requirements.txt
    echo "Done python"
}

function do_git {
    echo "Installing git stuff"
    if [ ! -d "$HOME/workspace" ]; then
	    mkdir -p "$HOME/workspace/git"
    elif [ ! -d "$HOME/workspace/git" ]; then
	    mkdir "$HOME/workspace/git"
    fi
    
    sh git_packages.sh
    echo "configuring YCMD"
    (cd "$HOME/workspace/git/ycmd/"; ./build --clang-completer)
    echo "Done git"
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

function do_zsh {
    chsh -s /usr/bin/zsh
    PREZTO="setopt EXTENDED_GLOB
	for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
		  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
	  done"
    zsh "$PREZTO"
    echo "Done zsh."
}

function install_fonts {
    mkdir $HOME/.local/share/fonts
    wget -O $HOME/.local/share/fonts/Inconsolata-dz-for-Powerline.otf \
         "https://github.com/powerline/fonts/blob/master/InconsolataDz/Inconsolata-dz%20for%20Powerline.otf?raw=true"
    fc-cache -fv 
}

function get_pacaur {
    git clone https://aur.archlinux.org/pacaur.git /tmp/
    git clone https://aur.archlinux.org/cower.git /tmp/
    (cd /tmp/cower; makepkg -si; cd ../pacaur/; makepkg -si)
}

function installaur_packages {
    package_file="aur"
    while read -r line; do
        pacaur -S "$line"
    done < "$package_file"
}

do_pacman
get_pacaur
installaur_packages
install_fonts
do_python
do_git
do_zsh
do_rvm

MACKUP_BIN="$HOME/.virtualenvs/pyenv/bin/mackup"
cp -r ../.mackup* ~/
$MACKUP_BIN restore
