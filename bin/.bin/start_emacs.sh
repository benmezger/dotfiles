#!/bin/bash

running=$(/usr/local/bin/emacsclient --eval '(daemonp)')

if [ $running ]; then
    /usr/local/bin/emacsclient -c --no-wait
else
    /usr/local/bin/emacs --daemon
    /usr/local/bin/emacsclient -c --no-wait
fi
