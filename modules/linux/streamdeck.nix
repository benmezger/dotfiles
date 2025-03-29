{
  userConf,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.streamdeck;
in
{
  options.my = {
    streamdeck.enable = lib.mkEnableOption "enable streamdeck config";
  };

  config = lib.mkIf cfg.enable {
    programs.streamdeck-ui = {
      enable = true;
      autoStart = true;
    };
  };
}
