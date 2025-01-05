{
  userConf,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.fwupd;
in
{
  options.my = {
    fwupd.enable = lib.mkEnableOption "enable fwudp";
  };

  config = lib.mkIf cfg.enable {
    services.fwupd.enable = true;
  };
}
