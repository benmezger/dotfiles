#!/bin/bash
# lightsOn.sh

# Copyright (c) 2011 iye.cba at gmail com, 2012-2017 unhammer at fsfe org
# URL: https://github.com/unhammer/lightsOn
# This script is licensed under GNU GPL version 2.0 or above

# Description: Bash script that prevents the screensaver and display
# power management (DPMS) to be activated when you are watching Flash
# Videos fullscreen on Firefox and Chromium. Can also detect mplayer,
# VLC and Parole, see the *_detection variables below.

# lightsOn.sh needs xscreensaver or kscreensaver to work.

# Prerequisites (Debian package / Arch Linux package):
# * pgrep (procps / procps-ng)
# * xset (x11-server-utils / xorg-xset)
# * xprop (x11-utils / xorg-xprop)

# USAGE: Start the script with the number of seconds you want the checks
# for fullscreen to be done. Example:
#
# ./lightsOn.sh 120
#
# will check every 120 seconds if e.g. Mplayer, VLC, Firefox or
# Chromium are fullscreen and delay screensaver and Power Management
# if so. You want the number of seconds to be some seconds less than
# the time it takes your screensaver or Power Management to activate.
#
# If you don't pass an argument, the checks are done every 50 seconds.

# Note: Firefox with HTML5 videos should prevent screensaver on Gnome
# and KDE, but does not yet do the right thing under XFCE:
# https://bugzilla.mozilla.org/show_bug.cgi?id=1168090 and I haven't
# yet found a good way to figure out if a fullscreen FF is playing an
# HTML5 video or not.

# Set the variable `screensaver' to the screensaver you use.
# Valid options are:
# * xscreensaver (default)
# * kscreensaver (the KDE screensaver)
screensaver=xscreensaver

# Modify these variables if you want this script to detect if Mplayer,
# VLC or Firefox Flash Video are Fullscreen and disable
# xscreensaver/kscreensaver and PowerManagement.
mplayer_detection=false
vlc_detection=true
parole_detection=true
firefox_flash_detection=true
firefox_mplayer_detection=true
chromium_flash_detection=true
mpv_detection=true

# Set to true to be verbose, false to be quiet:
verbose=true

# Note: if you're using xscreensaver and the built-in screensaver
# disabling of mplayer (or smplayer) does not work for you, you might
# be able to fix it by adding the line
#
# heartbeat-cmd="xscreensaver-command -deactivate >&- 2>&- &"
#
# to your ~/.mplayer/config and letting mplayer_detection=false in
# this script.


# YOU SHOULD NOT NEED TO MODIFY ANYTHING BELOW THIS LINE


xprop_active_info () {
    xprop -id "$(xprop -root _NET_ACTIVE_WINDOW | awk '{print $5}')"
}

maybe_delay_screensaver () {
    if we_are_fullscreen; then
	$verbose && echo "detected fullscreen"
        if app_is_running; then
	    $verbose && echo "app is running too, delaying"
            delay_screensaver
	else
	    $verbose && echo "but no relevant app detected"
        fi
    fi
}

we_are_fullscreen () {
    xprop_active_info | grep -q _NET_WM_STATE_FULLSCREEN
}

app_is_running () {
    active_win_title=$(xprop_active_info | grep "WM_CLASS(STRING)")
    $verbose && echo "	active window title: $active_win_title"

    if $mpv_detection &&
	[[ $active_win_title = *mpv* ]] &&
	pgrep mpv &>/dev/null; then
	$verbose && echo "	active win seems to be mpv"
	return 0
    fi

    if $mplayer_detection &&
	[[ $active_win_title = *mplayer* || $active_win_title = *MPlayer* ]] &&
	pgrep mplayer &>/dev/null; then
	$verbose && echo "	active win seems to be Mplayer"
	return 0
    fi

    if $vlc_detection &&
	[[ $active_win_title = *vlc* ]] &&
	pgrep vlc &>/dev/null; then
	$verbose && echo "	active win seems to VLC"
        return 0
    fi

    if $parole_detection &&
	[[ $active_win_title = *parole* ]] &&
	pgrep parole &>/dev/null; then
	$verbose && echo "	active win seems to Parole"
        return 0
    fi

    if $firefox_flash_detection &&
	[[ $active_win_title = *unknown* || $active_win_title = *plugin-container* ]] &&
	pgrep plugin-containe &>/dev/null; then
	$verbose && echo "	active win seems to be Firefox Flash"
	return 0
    fi

    if $firefox_mplayer_detection &&
	[[ $active_win_title = *mplayer* || $active_win_title = *MPlayer* ]] &&
	pgrep plugin-containe &>/dev/null; then
	$verbose && echo "	active win seems to be Firefox Mplayer"
        return 0
    fi

    if $chromium_flash_detection &&
	[[ $active_win_title = *chromium* ]] &&
	pgrep -f "chromium-browser --type=plugin --plugin-path=/usr/lib/adobe-flashplugin" &>/dev/null; then
	# TODO: the hardcoded path probably doesn't always work
	$verbose && echo "	active win seems to be Chromium"
        return 0
    fi

    return 1
}

delay_screensaver () {
    if [[ $screensaver = kscreensaver ]]; then
	qdbus org.freedesktop.ScreenSaver /ScreenSaver SimulateUserActivity > /dev/null
    else
	xscreensaver-command -deactivate > /dev/null
    fi

    if xset -q | grep -q 'DPMS is Enabled'; then
        # reset (deactivate and reactivate) DPMS status:
        xset -dpms
        xset dpms
    fi
}


delay=${1:-50}

if [[ $delay = *[^0-9]* || $delay = 0 ]]; then
    cat <<EOF
The argument \"$delay\" is invalid, expecting a positive integer
Please use the time in seconds you want the checks to repeat. You want
it to be less than the time it takes your screensaver or DPMS to
activate.
EOF
    exit 1
fi

while true; do
    maybe_delay_screensaver
    sleep "$delay"
done
