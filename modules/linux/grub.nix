{ config, lib, pkgs, ... }:

let
  cfg = config.my.grub;
in
{
  options.my = {
    grub.enable = lib.mkEnableOption "enable clipboard config";
  };

  config = lib.mkIf cfg.enable {
    boot.loader.grub = {
      useOSProber = true;
      enable = true;
      device = "nodev";
      efiSupport = true;
      enableCryptodisk = true;
      gfxmodeEfi = "1920x1440";
    };

    environment.systemPackages = with pkgs; [
      refind
    ];
  };
}
