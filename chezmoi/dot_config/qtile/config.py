from typing import List  # noqa: F401
import pathlib

from libqtile import layout
from libqtile.config import Click, Drag, Group, Key, Match, ScratchPad, DropDown
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

from screens import *

mod = "mod4"
terminal = guess_terminal()
personal_bin = str(pathlib.Path().home().joinpath(".bin"))

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(
        [mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"
    ),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key(
        [mod, "shift", "control"],
        "q",
        lazy.shutdown(),
        desc="Shutdown Qtile",
    ),
    Key(
        [mod, "control"],
        "x",
        lazy.spawn(f"sh {personal_bin}/lock"),
        desc="Lock screen",
    ),
    Key([mod], "d", lazy.spawn(f"rofi -show run"), desc="Spawn rofi launcher"),
    Key(
        [mod],
        "F10",
        lazy.spawn("/usr/bin/xfce4-screenshooter"),
        desc="Run XFCE4 screenshooter tool",
    ),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle full screen"),
    Key(
        [mod],
        "k",
        lazy.widget["keyboardlayout"].next_keyboard(),
        desc="Next keyboard layout",
    ),
    Key(
        [mod],
        "p",
        lazy.spawn(f"rofi -modi 'clipboard:greenclip print' -show"),
        desc="Clipboard history",
    ),
]

groups = [
    Group(i, **kwargs)
    for i, kwargs in [
        (
            "1",
            {
                "layout": "max",
                "spawn": ("vivaldi-stable",),
                "matches": [Match(wm_class=["vivaldi-stable"])],
            },
        ),
        (
            "2",
            {
                "layout": "monadtall",
                "spawn": (f"{terminal}",),
                "matches": [Match(wm_class=[f"{terminal}"])],
            },
        ),
        ("3", {"layout": "monadtall", "spawn": ("emacs",)}),
        ("4", {"layout": "monadtall"}),
        ("5", {"layout": "monadtall"}),
        ("6", {"layout": "monadtall"}),
        ("7", {"layout": "monadtall"}),
        ("8", {"layout": "monadtall"}),
        ("9", {"layout": "monadtall"}),
        (
            "0",
            {
                "layout": "monadtall",
                "spawn": (f"{terminal} -e zsh -i -c '/usr/bin/weechat'",),
                "matches": [Match(wm_class=["weechat"])],
            },
        ),
    ]
]

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

scratchpads = [
    ScratchPad(
        "scratchpad",
        dropdowns=(
            DropDown(
                "terminal",
                f"{terminal}",
                opacity=0.98,
                on_focus_lost_hide=True,
                height=0.8,
            ),
            DropDown(
                "emacs", "emacs", opacity=0.98, on_focus_lost_hide=True, height=0.9
            ),
        ),
    )
]

groups = groups + scratchpads
keys = keys + [
    Key([mod], "minus", lazy.group["scratchpad"].dropdown_toggle("terminal")),
    Key([mod], "equal", lazy.group["scratchpad"].dropdown_toggle("emacs")),
]

margin = 8
border_width = 0
layouts = [
    layout.MonadTall(border_width=border_width, margin=margin),
    layout.MonadWide(border_width=border_width, margin=margin),
    layout.Columns(
        border_focus_stack=["#d75f5f", "#8f3d3d"],
        border_width=border_width,
        margin=margin,
    ),
    layout.Max(border_width=border_width, margin=margin),
    layout.Bsp(border_width=border_width, margin=margin),
    layout.Stack(num_stacks=2, border_width=border_width, margin=margin),
    layout.Matrix(border_width=border_width, margin=margin),
    layout.RatioTile(border_width=border_width, margin=margin),
    layout.Tile(border_width=border_width, margin=margin),
    layout.TreeTab(border_width=border_width, margin=margin),
    layout.VerticalTile(border_width=border_width, margin=margin),
    layout.Zoomy(border_width=border_width, margin=margin),
]

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
        Match(title="qalculate-gtk"),  # qalculate-gtk
        Match(title="pcmanfm"),  # pcmanfm
    ],
    border_width=border_width,
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
