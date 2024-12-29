{ userConf, config, lib, pkgs, ... }:

let
  cfg = config.my.gnome;
in
{
  options.my = {
    gnome.enable = lib.mkEnableOption "enable gnome config";
  };

  config = lib.mkIf cfg.enable {
    services.gnome.gnome-keyring.enable = true;

    environment.systemPackages = with pkgs; [
      gnome-keyring
    ];
  };
}
