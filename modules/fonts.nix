{ config, lib, pkgs, ... }:

let
  cfg = config.my.fonts;
in
{
  options.my = {
    fonts.enable = lib.mkEnableOption "enable fonts config";
  };

  config = lib.mkIf cfg.enable {
    fonts.packages = [
      pkgs.nerd-fonts.hack
      pkgs.font-awesome
      pkgs.noto-fonts-emoji-blob-bin
      pkgs.source-code-pro
      pkgs.hack-font
    ];
  };
}
