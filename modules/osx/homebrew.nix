{ config, lib, pkgs, ... }:

let
  cfg = config.my.homebrew;
in
{
  options.my = {
    homebrew.enable = lib.mkEnableOption "enable homebrew config";
  };

  config = lib.mkIf cfg.enable {
    homebrew = {
      enable = true;
    };
  };
}
