#!/usr/bin/bash

# Test if $1 is available
isavailable() {
    type "$1" &>/dev/null
}

# screen powersave
xset +dpms
xset dpms 0 0 300

# run xrdb
[[ -f $HOME/.Xresources ]] && xrdb -load $HOME/.Xresources

# run urxvt daemon
[[ -z "$(pidof urxvtd)" ]] && urxvtd --quiet --opendisplay --fork

# start redshift
# current lat/log: oud-zuid
isavailable redshift && redshift -l "-27.578023":"-48.537449" &

# Here Xfce is kept as default
session=${1:-xfce}

case $session in
    i3|i3wm           ) exec i3;;
    xfce|xfce4        ) exec startxfce4;;
    # No known session, try to run it as command
    *) exec $1;;
esac

