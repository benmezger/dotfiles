#!/usr/bin/env python3
# coding: utf-8 -*-
# License: BSD
# Author: Ben Mezger (seds) <me@benmezger.nl>

import weechat
import functools
import pathlib
import mailbox
import time
import os

SCRIPT_NAME = "check_mail"
SCRIPT_AUTHOR = "Ben Mezger (seds) <me@benmezger.nl>"
SCRIPT_VERSION = "1.1"
SCRIPT_DESC = "Check for new emails"
SCRIPT_LICENSE = "BSD"
CONFIG_FILE_NAME = "check_mail"

conf = None
mail = None
mail_counter = 0


class Config:
    def __init__(
        self,
        filename=CONFIG_FILE_NAME,
        mailpath=str(pathlib.Path().home().joinpath("mail", "inbox")),
    ):

        self._config_file = None
        self._section_conf = None
        self._is_read = False
        self._mail_dir = None
        self._bar_text = None
        self._log_to_weechat = None
        self._interval = None

        self._config_file = weechat.config_new(filename, "", "")
        if self._config_file == "":
            weechat.prnt(
                "", f"{weechat.prefix('error')} Error reading check_mail config"
            )
            return

        self._section_conf = weechat.config_new_section(
            self._config_file, "conf", 0, 0, "", "", "", "", "", "", "", "", "", ""
        )

        if self._section_conf == "":
            weechat.config_free(self._config_file)
            weechat.prnt("", f"{weechat.prefix('error')} Error check_mail conf section")
            return

        # No keyword argument support =(
        self._mail_dir = weechat.config_new_option(
            self._config_file,
            self._section_conf,
            "maildir_path",
            "string",
            "Path of mail directory",
            "",
            0,
            0,
            mailpath,
            mailpath,
            0,
            "",
            "",
            "",
            "",
            "",
            "",
        )

        self._interval = weechat.config_new_option(
            self._config_file,
            self._section_conf,
            "interval",
            "integer",
            "Interval in seconds for triggering check mail",
            "",
            0,
            9999999,
            "1",
            "1",
            0,
            "",
            "",
            "",
            "",
            "",
            "",
        )

        self._bar_text = weechat.config_new_option(
            self._config_file,
            self._section_conf,
            "bar_text",
            "string",
            "Text to display",
            "",
            0,
            0,
            "MI",
            "MI",
            0,
            "",
            "",
            "",
            "",
            "",
            "",
        )

        self._log_to_weechat = weechat.config_new_option(
            self._config_file,
            self._section_conf,
            "log_to_weechat_buffer",
            "boolean",
            "Log new mails to weechat buffer",
            "",
            0,
            0,
            "on",
            "on",
            0,
            "",
            "",
            "",
            "",
            "",
            "",
        )
        self.reload()

    @property
    def config_file(self):
        return self._config_file

    @property
    def is_read(self):
        return self._is_read

    def read(self):
        """ Read configuration file. """
        weechat.config_read(self._config_file)
        self.reload()
        self._is_read = True

    def reload(self):
        self.mail_dir = weechat.config_string(self._mail_dir)
        self.bar_text = weechat.config_string(self._bar_text)
        self.interval = weechat.config_integer(self._interval)
        self.should_log = weechat.config_boolean(self._log_to_weechat)


class Mail:
    def __init__(self, config=Config(), **kwargs):
        self.config = config
        self.mail = mailbox.Maildir(self.config.mail_dir, **kwargs)

    def reload(self, **kwargs):
        self.mail = mailbox.Maildir(self.config.mail_dir, **kwargs)

    def refresh(self):
        return self.mail_refresh()

    def __str__(self):
        return f"{self.config.bar_text} {len(self.mail)}"

    def __len__(self):
        return len(self.mail)

    def set_timer(self):
        self._hook = weechat.hook_timer(
            self.config.interval,
            0,
            0,
            "on_timer_update",
            "",
        )
        return weechat.WEECHAT_RC_OK

    def disable_timer(self):
        if getattr(self, "_hook", None):
            weechat.unhook(self._hook)


def on_timer_update(*args, **kwargs):
    global mail_counter
    weechat.bar_item_update("check_mail")

    if conf.should_log:
        if len(mail) != mail_counter:
            mail_counter = len(mail)
            weechat.prnt(
                "", f"{weechat.prefix('action')}You have {len(mail)} unread mails"
            )

    return weechat.WEECHAT_RC_OK


def on_bar_item_update(*args, **kwargs):
    return f"{mail}{weechat.color('reset')}"


def on_config_changed(*args, **kwargs):
    global conf, mail
    conf.reload()
    mail.reload()
    on_bar_item_update()
    return weechat.WEECHAT_RC_OK


def create_bar_item():
    weechat.bar_item_new("check_mail", "on_bar_item_update", "")
    weechat.bar_item_update("check_mail")


if __name__ == "__main__":
    if weechat.register(
        SCRIPT_NAME, SCRIPT_AUTHOR, SCRIPT_VERSION, SCRIPT_LICENSE, SCRIPT_DESC, "", ""
    ):

        conf = Config()
        conf.read()
        mail = Mail(config=conf)

        weechat.hook_config("check_mail.*", "on_config_changed", "")
        create_bar_item()
        mail.set_timer()
