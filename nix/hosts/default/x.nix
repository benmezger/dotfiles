{ config, lib, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];

    desktopManager = {
      xterm.enable = false;
    };

    displayManager = {
      defaultSession = "none+exwm";
    };

    windowManager.exwm = {
      enable = true;
    };
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
}
