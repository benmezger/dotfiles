{
  userConf,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.ai;
in
{
  options.my = {
    ai.enable = lib.mkEnableOption "enable AI config";
  };

  config = lib.mkIf cfg.enable {
    services.ollama = {
      enable = true;
      acceleration = "cuda";
    };

    services.open-webui = {
      enable = true;
      port = 8085;
      host = "0.0.0.0";
    };
  };
}
