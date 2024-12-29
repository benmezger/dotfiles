{ config, lib, pkgs, ... }:

let
  cfg = config.my.gnupg;
in
{
  options.my = {
    gnupg.enable = lib.mkEnableOption "enable gnupg config";
  };

  config = lib.mkIf cfg.enable {
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-gtk2;
    };
  };
}
