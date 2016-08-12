#!/usr/bin/bash

# screen powersave
xset +dpms
xset dpms 0 0 300

# run xrdb
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

# run urxvt daemon
[[ -z "$(pidof urxvtd)" ]] && urxvtd --quiet --opendisplay --fork
