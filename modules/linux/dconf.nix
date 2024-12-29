{ config, lib, pkgs, ... }:

let
  cfg = config.my.dconf;
in
{
  options.my = {
    dconf.enable = lib.mkEnableOption "enable dconf config";
  };

  config = lib.mkIf cfg.enable {
    programs.dconf.enable = true;
  };
}
