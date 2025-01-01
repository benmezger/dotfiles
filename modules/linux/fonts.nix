{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.fonts;
in
{
  config = lib.mkIf cfg.enable {
    fonts.fontconfig.enable = true;
  };
}
