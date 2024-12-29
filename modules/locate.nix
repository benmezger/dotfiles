{ config, lib, pkgs, ... }:

let
  cfg = config.my.locate;
in
{
  options.my = {
    locate.enable = lib.mkEnableOption "enable locate config";
  };

  config = lib.mkIf cfg.enable {
    services.locate.enable = true;

    environment.systemPackages = with pkgs; [
      mlocate
    ];
  };
}
