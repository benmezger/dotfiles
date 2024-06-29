import webbrowser
from libqtile import bar, widget, hook, qtile
from libqtile.config import Screen
from widgets import NordVPN
from theme import gruvbox_dark

widget_defaults = dict(
    font="Hack",
    fontsize=30,
    padding=3,
)

extension_defaults = widget_defaults.copy()
reconfigure_screens = True

default_screen_widgets = lambda: [
    widget.GroupBox(),
    widget.WindowName(),
    widget.Clock(),
]

default_screen_left_widgets = lambda: [
    widget.CurrentLayoutIcon(),
    widget.Spacer(length=10),
    widget.Sep(),
    widget.Spacer(length=10),
    widget.GroupBox(
        borderwidth=1,
        disable_drag=True,
        font="Hack",
        highlight_method="text",
        active=gruvbox_dark["foreground"],
        this_current_screen_border=gruvbox_dark["yellow"],
    ),
    widget.Spacer(length=10),
    widget.Spacer(length=bar.STRETCH),
]

default_screen_right_widgets = lambda: [
    widget.WidgetBox(
        widgets=[
            widget.Spacer(length=20),
            widget.WidgetBox(
                widgets=[
                    widget.CPU(fmt="{}"),
                    widget.Memory(fmt=" {} "),
                    widget.ThermalSensor(fmt=" {} ", font="Hack Nerd Font"),
                ],
            ),
            widget.Spacer(length=10),
            widget.Sep(),
            widget.Volume(fmt="󰕾 {}", font="Hack Nerd Font"),
            widget.Spacer(
                length=10,
            ),
            widget.Sep(),
            widget.Spacer(length=10),
            widget.OpenWeather(
                font="Hack Nerd Font",
                location="Amsterdam",
                format="ams: {main_temp} °{units_temperature}",
                mouse_callbacks={
                    "Button1": lambda: webbrowser.open_new_tab(
                        "https://wttr.in/amsterdam"
                    )
                },
            ),
            widget.Spacer(length=10),
            widget.Sep(),
            widget.Spacer(length=10),
            widget.KeyboardLayout(
                configured_keyboards=("us", "br"),
                fmt="󰌓 {}",
                font="Hack Nerd Font",
            ),
            widget.Spacer(length=10),
            widget.Sep(),
            widget.Spacer(length=10),
            widget.Clock(
                format="%H:%M:%S",
                fmt=" {} ",
                font="Hack Nerd Font",
                mouse_callbacks={
                    "Button1": lambda: webbrowser.open_new_tab(
                        "https://calendar.google.com/calendar/u/0/r"
                    )
                },
            ),
            widget.Clock(
                format="%h %d %Y",
                fmt=" {}",
                font="Hack Nerd Font",
                mouse_callbacks={
                    "Button1": lambda: webbrowser.open_new_tab(
                        "https://calendar.google.com/calendar/u/0/r"
                    )
                },
            ),
            widget.Spacer(length=10),
            widget.Sep(),
            widget.Spacer(length=10),
        ]
    )
]

screens = [
    Screen(
        top=bar.Bar(
            default_screen_left_widgets()
            + [widget.Spacer(length=bar.STRETCH)]
            + default_screen_right_widgets()
            + [widget.Systray(icon_size=40)],
            size=60,
            margin=8,
            background=gruvbox_dark["background"],
            border_width=[0, 0, 0, 0],
        )
    ),
    Screen(
        top=bar.Bar(
            default_screen_left_widgets()
            + [widget.Spacer(length=bar.STRETCH)]
            + default_screen_right_widgets(),
            size=60,
            margin=8,
            background=gruvbox_dark["background"],
            border_width=[0, 0, 0, 0],
        )
    ),
    Screen(
        top=bar.Bar(
            default_screen_left_widgets()
            + [widget.Spacer(length=bar.STRETCH)]
            + default_screen_right_widgets(),
            size=60,
            margin=8,
            background=gruvbox_dark["background"],
            border_width=[0, 0, 0, 0],  # Draw top and bottom borders
        ),
    ),
]


@hook.subscribe.screen_change
def on_screens_reconfigured(_):
    qtile.cmd_reload_config()
