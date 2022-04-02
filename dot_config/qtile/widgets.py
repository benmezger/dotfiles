#!/usr/bin/env python3

# Author: Ben Mezger <me@benmezger.nl>
# Created at <2022-03-31 Thu 12:32>

from libqtile.widget import base
import subprocess
import pathlib
from countries import COUNTRIES

NORDVPN_BIN = pathlib.Path("/usr/bin/").absolute().joinpath("nordvpn")


class NordVPN(base.InLoopPollText):
    """Check if NordVPN is connected"""

    defaults = [
        (
            "format",
            "{status} {ip} @ {country}",
            "Format of the displayed text. Available variables:",
            "{status} == connection status, {ip} = connection ip"
            "{country} == connected country",
        ),
        ("update_interval", 900, "Update interval in seconds for the clock"),
        ("connected_char", "c", "The character to display when VPN is connected"),
        ("disconnected_char", "d", "The character to display when VPN is disconnected"),
    ]

    def __init__(self, **config):
        base.InLoopPollText.__init__(self, **config)
        self.add_defaults(NordVPN.defaults)

    def poll(self):
        proc = subprocess.Popen(
            f"{NORDVPN_BIN} status", stdout=subprocess.PIPE, shell=True
        )
        proc.wait()

        status = self.disconnected_char
        country = ""
        ip = ""

        for line in proc.stdout:
            line = line.decode().strip().lower()
            if "status: connected" in line:
                status = self.connected_char
            if "country:" in line:
                country = line[line.find(":") + 2 :].title()
            if "server ip:" in line:
                ip = line[line.find(":") + 2 :].title()

        return (
            "VPN/off"
            if status == self.disconnected_char
            else self.format.format(
                **dict(status=status, country=COUNTRIES.get(country), ip=ip)
            )
        )
