{
  userConf,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.thunar;
in
{
  options.my = {
    thunar.enable = lib.mkEnableOption "enable thunar config";
  };

  config = lib.mkIf cfg.enable {
    # enable thunar + disk management
    programs.xfconf.enable = true;
    programs.thunar.enable = true;
    programs.thunar.plugins = with pkgs.xfce; [
      thunar-volman
      thunar-archive-plugin
      thunar-media-tags-plugin
    ];

    services.gvfs.enable = true;
    services.tumbler.enable = true;
  };
}
