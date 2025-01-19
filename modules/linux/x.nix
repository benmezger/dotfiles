{
  config,
  lib,
  pkgs,
  ...
}:

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
      videoDrivers = [ "nvidia" ];

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

      displayManager = {
        setupCommands = ''
          ${pkgs.xorg.xrandr}/bin/xrandr \
            --output HDMI-0 --mode 3840x2160 --pos 2160x0 \
            --output HDMI-1 --mode 3840x2160 --pos 0x480 --rotate right \
            --output DP-2 --primary --mode 3840x2160 --pos 2160x2160 \
            --output DP-0 --off \
            --output DP-1 --off \
            --output DP-3 --off \
            --output DP-4 --off \
            --output DP-5 --off
        '';
      };
    };

    services.displayManager.defaultSession = "none+i3";
    services.xserver.displayManager.session = [
      {
        manage = "desktop";
        name = "xsession";
        start = ''
          exec ~/.xsession
        '';
      }
    ];

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };
  };
}
