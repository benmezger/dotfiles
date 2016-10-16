#!/usr/bin/bash

# screen powersave
xset +dpms
xset dpms 0 0 300

# run xrdb
[[ -f $HOME/.Xresources ]] && xrdb -load $HOME/.Xresources

# run urxvt daemon
[[ -z "$(pidof urxvtd)" ]] && urxvtd --quiet --opendisplay --fork

# Here Xfce is kept as default
session=${1:-xfce}

case $session in
    i3|i3wm           ) exec i3;;
    xfce|xfce4        ) exec startxfce4;;
    # No known session, try to run it as command
    *) exec $1;;
esac

