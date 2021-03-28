# encoding: utf-8
# Author: Lukasz Korecki <lukasz at coffeesounds dot com>
# Homepage: https://github.com/lukaszkorecki/weechat-tmux-notify

# Version: 0.1
#
# Requires Weechat 0.3
# Released under GNU GPL v2
#
# Based (roughly) on http://github.com/tobypadilla/gnotify
# gnotify is derived from notify http://www.weechat.org/files/scripts/notify.py
# Original author: lavaramano <lavaramano AT gmail DOT com>

import weechat, string, os

weechat.register(
    "tmuxnotify",
    "lukaszkorecki",
    "0.1",
    "GPL",
    "tmuxnotify: weechat notifications in tmux",
    "",
    "",
)

# script options
settings = {
    "show_hilights": "on",
    "show_priv_msg": "on",
    "time_in_secs": "5",
}


for option, default_value in settings.items():
    if weechat.config_get_plugin(option) == "":
        weechat.config_set_plugin(option, default_value)


# Hook privmsg/hilights
weechat.hook_signal("weechat_pv", "notify_show_priv", "")
weechat.hook_signal("weechat_highlight", "notify_show_hi", "")


def parse_message(message):
    # clean message
    message = message.split("\t")
    # get user how mentioned me
    user = " ".join(message).split(" ")[0]
    # remove user from message
    message = " ".join(message[1:])

    return user, message


# Functions
def notify_show_hi(data, signal, message):
    """Sends highlight message to be printed on notification"""

    user, message = parse_message(message)
    if weechat.config_get_plugin("show_hilights") == "on":
        show_notification("IRC mention from {}: {}".format(user, message[:10] + "..."))
    return weechat.WEECHAT_RC_OK


def notify_show_priv(data, signal, message):
    """Sends private message to be printed on notification"""

    user, message = parse_message(message)
    if weechat.config_get_plugin("show_priv_msg") == "on":
        show_notification("IRC message from {}: {}".format(user, message[:10] + "..."))
    return weechat.WEECHAT_RC_OK


def show_notification(message):
    secs = int(weechat.config_get_plugin("time_in_secs"))
    os.popen(
        "tmux set display-time {0} && tmux display-message '{1}' &".format(
            secs * 1000, message
        )
    )
