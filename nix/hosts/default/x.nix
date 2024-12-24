{ config, lib, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];

    desktopManager = {
      xterm.enable = false;
    };

    windowManager.exwm = {
      enable = true;
    };
  };

  services.displayManager.defaultSession = "none+exwm";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
}
