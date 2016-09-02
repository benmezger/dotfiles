#!/usr/bin/bash

# screen powersave
xset +dpms
xset dpms 0 0 300

# run xrdb
[[ -f $HOME/.Xresources ]] && xrdb -load $HOME/.Xresources

# run urxvt daemon
[[ -z "$(pidof urxvtd)" ]] && urxvtd --quiet --opendisplay --fork
