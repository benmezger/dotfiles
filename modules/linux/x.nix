{ config, lib, pkgs, ... }:

let
  cfg = config.my.x;
in
{
  options.my = {
    x.enable = lib.mkEnableOption "enable X config";
  };

  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;
      videoDrivers = ["nvidia"];

      desktopManager = {
        xterm.enable = false;
      };

      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        extraPackages = with pkgs; [
          i3status-rust
          i3lock
        ];
      };
    };

    services.displayManager.defaultSession = "none+i3";
    services.xserver.displayManager.session = [{
      manage = "desktop";
      name = "xsession";
      start = ''
        exec ~/.xsession
      '';
    }];

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };
  };
}
