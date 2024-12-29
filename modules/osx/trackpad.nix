{ config, lib, pkgs, ... }:

let
  cfg = config.my.trackpad;
in
{
  options.my = {
    trackpad.enable = lib.mkEnableOption "enable trackpad config";
  };

  config = lib.mkIf cfg.enable {
    system.defaults.NSGlobalDomain."com.apple.trackpad.forceClick" = true;
    system.defaults.trackpad.Clicking = true;
    system.defaults.NSGlobalDomain."com.apple.mouse.tapBehavior" = 1;
  };
}
