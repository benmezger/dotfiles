#!/bin/bash
# lightsOn.sh

# Original version by iye.cba at gmail com
# url: https://github.com/iye/lightsOn
#
# Compilation version by Yegor Bayev
# url: https://github.com/kodx/lightsOn
#
# Contributors:
# Dylan Smith (https://github.com/dyskette/lightsOn)
# Andrew West (https://github.com/namtabmai/lightsOn)
#
# This script is licensed under GNU GPL version 2.0 or above

# Description: Bash script that prevents the screensaver and display power
# management (DPMS) to be activated when you are watching Flash or HTML5 Videos.
#
# It can detect mpv, mplayer, minitube, and VLC when they are fullscreen too.
# Also, screensaver can be prevented when certain specified programs are running.
# Optionally delay the screensaver when specific outputs are connected.

# HOW TO USE: Start the script with the number of seconds you want the checks
# for fullscreen to be done. Example:
#
# "./lightsOn.sh 120 &" will Check every 120 seconds if any of the supported
# applications are fullscreen and delay screensaver and Power Management if so.

# You want the number of seconds to be ~10 seconds less than the time it takes
# your screensaver or Power Management to activate. If you don't pass an
# argument, the checks are done every X seconds. Where X is calculated based on
# your system sleep time, with a minimum of $default_sleep_delay.

# An optional array variable exists here to add the names of programs that will
# delay the screensaver if they're running. This can be useful if you want to
# maintain a view of the program from a distance, like a music playlist.

# If you use this feature, make sure you use the name of the binary of the
# program (which may exist, for instance, in /usr/bin).

# VERSION=v0.1

# DEBUG=0 for no output
# DEBUG=1 for sleep prints
# DEBUG=2 for everything
DEBUG=0

# this is actually the minimum allowed dynamic delay.
# Also the default (if everything else fails)
default_sleep_delay=50

# Modify these variables if you want this script to detect if MPV, Mplayer,
# VLC, Minitube, Totem or a web browser Flash/HTML5 Video.
mplayer_detection=1
mpv_detection=1
vlc_detection=1
totem_detection=1
firefox_flash_detection=1
firefox_html5_detection=1
chromium_flash_detection=1
chromium_html5_detection=1
chromium_pepper_flash_detection=1
chrome_pepper_flash_detection=1
chrome_html5_detection=1
opera_flash_detection=1
opera_html5_detection=1
epiphany_html5_detection=1
webkit_flash_detection=1
minitube_detection=0
gsettings_present=$(if [ -x $(which gsettings) ]; then echo 1; else echo 0; fi)
xdg_screensaver_present=$(if [ -x $(which xdg-screensaver) ]; then echo 1; else echo 0; fi)

# Names of the programs of which, when running, you wish to delay the screensaver.
delay_progs=() # For example ('ardour2' 'gmpc')

# Display outputs to check, display screensaver when they are connected
# rund xrandr to show current monitor config
output_detection_control=0
output_detection=('HDMI-0')

# DPMS settings in seconds, 600 seconds = 10 minutes.
# if you don't want to change DMPS settings, use DPMS_Control=0
DPMS_Control=1
DPMS_StandbyTime=600
DPMS_SuspendTime=600
DPMS_OffTime=600

# X11 Screen Saver Extension settings in seconds, 600 seconds = 10 minutes.
# if you don't want to change X11 Scrensaver Extension settings, use X11ScreenSaver_Control=0
X11ScreenSaver_Control=1
X11ScreenSaver_Timeout=600

# YOU DO NOT NEED TO MODIFY ANYTHING BELOW THIS LINE
# --------------------------------------------------

log() {
    if [ $DEBUG -eq 2 ]; then
        echo $@
    elif [ $DEBUG -eq 1 ]; then
        if [ "$(echo $@ | grep -c "sleeping for")" == "1" ]; then
            echo $@
        fi
    fi
}

# setting DPMS
if [ $DPMS_Control == 1 ]; then
    log "Setting DPMS to Standby: $DPMS_StandbyTime, Suspend: $DPMS_SuspendTime, Off: $DPMS_OffTime"
    xset dpms $DPMS_StandbyTime $DPMS_SuspendTime $DPMS_OffTime
fi

# setting X11 Scrensaver Extension
if [ $X11ScreenSaver_Control == 1 ]; then
    log "Setting X11 Scrensaver Extension to Timeout: $X11ScreenSaver_Timeout"
    xset s $X11ScreenSaver_Timeout
fi

# enumerate all the attached screens
displays=""
while read id
do
    displays="$displays $id"
done < <(xvinfo | sed -n 's/^screen #\([0-9]\+\)$/\1/p')

# Detect screensaver been used
if [ "$(pidof -s xscreensaver)" ]; then
    screensaver=xscreensaver
    log "xscreensaver detected"
elif [ "$(pidof -s kscreensaver)" ]; then
    screensaver=kscreensaver
    log "kscreensaver detected"
elif [ "$(pidof -s xautolock)" ]; then
    screensaver=xautolock
    log "xautolock detected"
elif [ $(pgrep -cf "(gnome-screensaver|/usr/bin/gnome-screensaver)") -ge 1 ]; then
    screensaver=gnome-screensaver
    log "gnome-screensaver detected"
elif [ "$(pidof -s cinnamon-screen)" ]; then
    screensaver=cinnamon-screensaver
    log "cinnamon-screensaver detected"
else
    screensaver=None
    log "No screensaver detected"
fi

checkDelayProgs()
{
    log "checkDelayProgs()"
    for prog in "${delay_progs[@]}"; do
        if [ $(pgrep -lfc "$prog") -ge 1 ]; then
            log "checkDelayProgs(): Delaying the screensaver because a program on the delay list, \"$prog\", is running..."
            delayScreensaver
            break
        fi
    done
}

checkFullscreen()
{
    log "checkFullscreen()"
    # loop through every display looking for a fullscreen window
    for display in $displays
    do
        #get id of active window and clean output
        activ_win_id=$(DISPLAY=:0.${display} xprop -root _NET_CLIENT_LIST_STACKING | sed 's/.*\, //') #previously used _NET_ACTIVE_WINDOW, but it didn't work with some flash players (eg. Twitch.tv) in firefox. Using sed because id lengths can vary.

        # Skip invalid window ids (commented as I could not reproduce a case
        # where invalid id was returned, plus if id invalid
        # isActivWinFullscreen will fail anyway.)
        #if [ "$activ_win_id" = "0x0" ]; then
        #     continue
        #fi

        # Check if Active Window (the foremost window) is in a fullscreen state
        if [[ -n $activ_win_id ]]; then
            isActivWinFullscreen=$(DISPLAY=:0.${display} xprop -id $activ_win_id | grep _NET_WM_STATE_FULLSCREEN)
            isActivWinAbove=$(DISPLAY=:0.${display} xprop -id $activ_win_id | grep _NET_WM_STATE_ABOVE)
            log "checkFullscreen(): Display: $display isFullScreen: \"$isActivWinFullscreen\""
            log "checkFullscreen(): Display: $display isAbove: \"$isActivWinAbove\""
            if [[ "$isActivWinFullscreen" = *NET_WM_STATE_FULLSCREEN* || "$isActivWinAbove" = *NET_WM_STATE_ABOVE* ]];then
                log "checkFullscreen(): Fullscreen detected"
                isAppRunning
                var=$?
                if [[ $var -eq 1 ]];then
                    delayScreensaver
                    return
                fi
            # If no Fullscreen is active => set dpms on
            else
                log "checkFullscreen(): NO fullscreen detected"
                xset dpms

                # Turn on X11 Screensaver if necessary
                X11ScreensaverStatus=$(xset q | grep timeout | sed "s/cycle.*$//" | tr -cd [:digit:])
                if [ $X11ScreensaverStatus -eq 0 ]; then
                    log "checkFullscreen(): enabling X11 Screensaver Extension"
                    xset s on
                fi

            fi
        fi
    done
}

# check if an active window is mplayer, vlc or firefox
#TODO only a window name in the variable activ_win_id, not whole line.
#Then change IFs to detect more specifically the apps "<vlc>" and if a process name exists

isAppRunning()
{
    log "isAppRunning()"
    #Get title of active window
    activ_win_title=$(xprop -id $activ_win_id | grep "WM_CLASS(STRING)")

    # Check if a user wants to detect Video fullscreen on Firefox, modify variable firefox_flash_detection if you dont want Firefox detection
    if [ $firefox_flash_detection == 1 ];then
        if [[ "$activ_win_title" = *unknown* || "$activ_win_title" = *plugin-container* ]];then
            # Check if plugin-container process is running
            if [ "$(pidof -s plugin-container)" ];then
                log "isAppRunning(): firefox flash fullscreen detected"
                return 1
            fi
        fi
    fi

    # Check if a user wants to detect HTML Video fullscreen on Firefox, modify variable firefox_html5_detection if you dont want Firefox detection
    if [ $firefox_html5_detection == 1 ];then
        if [[ "$activ_win_title" = *Firefox* || "$activ_win_title" = *Iceweasel* ]];then
            # Check if firefox process is actually running
            # firefox_process=$(pgrep -c "(firefox|/usr/bin/firefox|iceweasel|/usr/bin/iceweasel)")
            if [ "$(pidof -s firefox iceweasel)" ];then
                log "isAppRunning(): firefox html5 fullscreen detected"
                return 1
            fi
        fi
    fi

    # Check if a user wants to detect Video fullscreen on Chromium, modify variable chromium_flash_detection if you dont want Chromium detection
    if [ $chromium_flash_detection == 1 ];then
        if [[ "$activ_win_title" = *exe* || "$activ_win_title" = *hromium* ]];then
            # Check if Chromium Flash process is running
            flash_process=$(pgrep -lfc ".*chromium.*flashp.*")
            if [[ $flash_process -ge 1 ]];then
                log "isAppRunning(): chromium flash fullscreen detected"
                return 1
            fi
        fi
    fi

    # Check if a user wants to detect html5 fullscreen on Chromium, modify variable chromium_html5_detection if you dont want Chromium html5 detection.
    if [ $chromium_html5_detection == 1 ];then
        if [[ "$activ_win_title" == *hromium* ]];then
            # Check if Chromium html5 process is running
            if [[ $(pgrep -c "chromium") -ge 1 ]];then
                log "isAppRunning(): chromium html5 fullscreen detected"
                return 1
            fi
        fi
    fi

    # Check if a user wants to detect flash fullscreen on Chromium, modify variable chromium_pepper_flash_detection if you dont want Chromium pepper flash detection.
    if [ $chromium_pepper_flash_detection == 1 ];then
        if [[ "$activ_win_title" = *hromium* ]];then
        # Check if Chromium Flash process is running
            chrome_process=$(pgrep -lfc "chromium(|-browser) --type=ppapi ")
            if [[ $chrome_process -ge 1 ]];then
                log "isAppRunning(): chromium flash fullscreen detected"
                return 1
            fi
        fi
    fi

    # Check if a user wants to detect flash fullscreen on Chrome, modify variable chrome_pepper_flash_detection if you dont want Chrome pepper flash detection.
    if [ $chrome_pepper_flash_detection == 1 ];then
        if [[ "$activ_win_title" = *oogle-chrome* ]];then
        # Check if Chrome Flash process is running
            chrome_process=$(pgrep -lfc "(c|C)hrome --type=ppapi ")
            if [[ $chrome_process -ge 1 ]];then
                log "isAppRunning(): chrome flash fullscreen detected"
                return 1
            fi
        fi
    fi

    # Check if a user wants to detect html5 fullscreen on Chrome, modify variable chrome_html5_detection if you dont want Chrome html5 detection.
    if [ $chrome_html5_detection == 1 ];then
        if [[ "$activ_win_title" = *oogle-chrome* ]];then
        # Check if Chrome html5 process is running
            #chrome_process=`pgrep -lfc "(c|C)hrome --type=gpu-process "`
            # Sorry, I didn't see any gpu-process in my pc
            chrome_process=$(pgrep -lfc "(c|C)hrome")
            if [[ $chrome_process -ge 1 ]];then
                log "isAppRunning(): chrome html5 fullscreen detected"
                return 1
            fi
        fi
    fi

    # Check if a user wants to detect Video fullscreen on Opera, modify variable opera_flash_detection
    if [ $opera_flash_detection == 1 ];then
        if [[ "$activ_win_title" = *operapluginwrapper* ]];then
        # Check if Opera flash process is running
            flash_process=$(pgrep -lfc operapluginwrapper-native)
            if [[ $flash_process -ge 1 ]];then
                log "isAppRunning(): opera flash fullscreen detected"
                return 1
            fi
        fi
    fi

    # Check if a user wants to detect html5 fullscreen on Opera, modify variable chrome_html5_detection if you dont want Opera html5 detection.
    if [ $opera_html5_detection == 1 ];then
        if [[ "$activ_win_title" = *opera* ]];then
        # Check if Opera html5 process is running
            if [ "$(pidof -s opera)" ];then
                log "isAppRunning(): opera html5 fullscreen detected"
                return 1
            fi
        fi
    fi

    # Check if a user wants to detect html5 fullscreen on Epiphany, modify variable epiphany_html5_detection if you dont want Epiphany html5 detection.
    if [ $epiphany_html5_detection == 1 ];then
        if [[ "$activ_win_title" = *epiphany* ]];then
        # Check if Epiphany html5 process is running
            if [[ "$(pidof -s epiphany)" ]];then
                log "isAppRunning(): epiphany html5 fullscreen detected"
                return 1
            fi
        fi
    fi

    # Check if a user wants to detect Video fullscreen on WebKit, modify variable webkit_flash_detection if you dont want Webkit detection
    if [ $webkit_flash_detection == 1 ];then
        if [[ "$activ_win_title" = *WebKitPluginProcess* ]];then
        # Check if WebKit Flash process is running
            flash_process=$(pgrep -lfc ".*WebKitPluginProcess.*flashp.*")
            if [[ $flash_process -ge 1 ]];then
                log "isAppRunning(): webkit flash fullscreen detected"
                return 1
            fi
        fi
    fi

    #Check if a user wants to detect mplayer fullscreen, modify variable mplayer_detection
    if [ $mplayer_detection == 1 ];then
        if [[ "$activ_win_title" = *mplayer* || "$activ_win_title" = *MPlayer* ]];then
            #check if mplayer is running.
            if [ "$(pidof -s mplayer)" ];then
                log "isAppRunning(): mplayer fullscreen detected"
                return 1
            fi
        fi
    fi

    #Check if a user wants to detect totem fullscreen, modify variable totem_detection
    if [ $totem_detection == 1 ];then
        if [[ "$activ_win_title" = *totem* ]];then
            #check if totem is running.
            if [ "$(pidof -s totem)" ];then
                log "isAppRunning(): totem fullscreen detected"
                return 1
            fi
        fi
    fi

    #Check if a user wants to detect mpv fullscreen, modify variable mpv_detection
    if [ $mpv_detection == 1 ];then
        if [[ "$activ_win_title" = *mpv* ]];then
            #check if mpv is running.
            if [ "$(pidof -s mpv)" ];then
                log "isAppRunning(): mpv fullscreen detected"
                return 1
            fi
        fi
    fi

    # Check if a user wants to detect vlc fullscreen, modify variable vlc_detection
    if [ $vlc_detection == 1 ];then
        if [[ "$activ_win_title" = *vlc* ]];then
            #check if vlc is running.
            if [ "$(pidof -s vlc)" ];then
                log "isAppRunning(): vlc fullscreen detected"
                return 1
            fi
        fi
    fi

    # Check if a user wants to detect minitube fullscreen, modify variable minitube_detection
    if [ $minitube_detection == 1 ];then
        if [[ "$activ_win_title" = *minitube* ]];then
            #check if minitube is running.
            if [ "$(pidof -s minitube)" ];then
                log "isAppRunning(): minitube fullscreen detected"
                return 1
            fi
        fi
    fi

return 0
}

delayScreensaver()
{
    # reset inactivity time counter so screensaver is not started
    if [ "$screensaver" == "xscreensaver" ]; then
        log "delayScreensaver(): delaying xscreensaver..."
        xscreensaver-command -deactivate > /dev/null
    elif [ "$screensaver" == "kscreensaver" ]; then
        log "delayScreensaver(): delaying kscreensaver..."
        qdbus org.freedesktop.ScreenSaver /ScreenSaver SimulateUserActivity > /dev/null
    elif [ "$screensaver" == "xautolock" ]; then
        log "delayScreensaver(): delaying xautolock..."
        xautolock -disable
        xautolock -enable
    elif [ "$screensaver" == "gnome-screensaver" ]; then
        log "delayScreensaver(): delaying gnome-screensaver..."
        dbus-send --session --dest=org.gnome.ScreenSaver --type=method_call /org/gnome/ScreenSaver org.gnome.ScreenSaver.SimulateUserActivity >/dev/null 2>&1
    elif [ "$screensaver" == "cinnamon-screensaver" ]; then
        log "delayScreensaver(): delaying cinnamon-screensaver..."
        dbus-send --session --dest=org.cinnamon.ScreenSaver --type=method_call /org/cinnamon/ScreenSaver org.cinnamon.ScreenSaver.SimulateUserActivity >/dev/null 2>&1
    else
        if [ $xdg_screensaver_present == 1 ]; then
            log "delayScreensaver(): trying to delay with xdg-screensaver..."
            xdg-screensaver reset
        fi
    fi

    # Check if DPMS is on. If it is, deactivate. If it is not, do nothing.
    dpmsStatus=$(xset -q | grep -c 'DPMS is Enabled')
    if [ $dpmsStatus == 1 ];then
        xset -dpms
        # moved to checkFullscreen().
        #xset dpms
    fi

    # Turn off X11 Screensaver if necessary
    X11ScreensaverStatus=$(xset q | grep timeout | sed "s/cycle.*$//" | tr -cd [:digit:])
    if [ $X11ScreensaverStatus -ge 1 ]; then
        log "delayScreensaver(): turning X11 Screensaver Extension off"
        xset s off
    fi

    # Reset gnome session idle timer
    if [[ $gsettings_present == 1 && $(gsettings get org.gnome.desktop.session idle-delay 2>/dev/null) ]]; then
        sessionIdleDelay=$(gsettings get org.gnome.desktop.session idle-delay 2>/dev/null | sed "s/^.* //")
        if [[ $sessionIdleDelay -ge 1 ]];then
            log "delayScreensaver(): resetting gnome session..."
            gsettings set org.gnome.desktop.session idle-delay 0 2>/dev/null
            gsettings set org.gnome.desktop.session idle-delay $sessionIdleDelay 2>/dev/null
        fi
    fi
}

checkOutputs()
{
    if [ $output_detection_control == 0 ]; then
        return
    fi

    declare -A connected_outputs
    while read line
    do
        declare output
        IFS="=" read -a info <<< "$line"
        if [[ "${info[0]}" = "output" ]]; then
            output=${info[1]}
        elif [[ "${info[0]}" = "connected" && "${info[1]}" = "connected" ]]; then
            connected_outputs["${output}"]="connected"
        fi
    done < <(xrandr | sed -rn "s/^([^ ]+)[ ]+((dis)?connected)[ ]+(primary)?[ ]*([0-9]+x[0-9]+\+[0-9]+\+[0-9]+)?[ ]*.+$/output=\1\nconnected=\2\nignore=\3\nprimary=\4\nresolution=\5/p")

    for output in $output_detection
    do
        if [[ ${connected_outputs["$output"]} = "connected" ]]; then
            log "checkOutputs(): Delaying because of output"
            delayScreensaver
            return
        fi
    done
}

_sleep()
{
    if [ $dynamicDelay -eq 0 ]; then
        log "sleeping for $delay"
        sleep $delay
    else
        if [ -f /sys/class/power_supply/AC/online ]; then
            if [ $gsettings_present == 1 ]; then
                if [ "$(cat /sys/class/power_supply/AC/online)" == "1" ]; then
                    system_sleep_delay=$(gsettings get org.gnome.settings-daemon.plugins.power sleep-display-ac 2>/dev/null)
                else
                    system_sleep_delay=$(gsettings get org.gnome.settings-daemon.plugins.power sleep-display-battery 2>/dev/null)
                fi
            fi
        fi
        if [ "$(echo $system_sleep_delay | egrep -c "^[0-9]+$")" == "1" ]; then
            if [ $system_sleep_delay -le $(($default_sleep_delay+5)) ]; then
                sleep_delay=$default_sleep_delay
            else
                sleep_delay=$(($system_sleep_delay-5))
            fi
        else
            sleep_delay=$default_sleep_delay
        fi
        log "sleeping for $sleep_delay (system idle timeout is $system_sleep_delay)"
        sleep $sleep_delay
    fi
}

delay=$1
dynamicDelay=0

# If argument empty, use dynamic delay.
if [ -z "$1" ];then
    dynamicDelay=1
    log "no delay specified, dynamicDelay=1"
fi

# If argument is not integer quit.
if [[ $1 = *[^0-9]* ]]; then
    echo "The Argument \"$1\" is not valid, not an integer"
    echo "Please use the time in seconds you want the checks to repeat."
    echo "You want it to be ~10 seconds less than the time it takes your screensaver or DPMS to activate"
    exit 1
fi

while true
do
    checkDelayProgs
    checkFullscreen
    checkOutputs
    _sleep $delay
done

exit 0
