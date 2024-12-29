{ userConf, config, lib, pkgs, ... }:

let
  cfg = config.my.clipboard;
in
{
  options.my = {
    clipboard.enable = lib.mkEnableOption "enable clipboard config";
  };

  config = lib.mkIf cfg.enable {
    services.greenclip.enable = true;
  };
}
