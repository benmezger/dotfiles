{ config, lib, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];

    desktopManager = {
      xterm.enable = false;
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        i3status-rust
        i3lock
      ];
    };
  };

  services.displayManager.defaultSession = "none+i3";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
}
