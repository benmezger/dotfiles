{
  userConf,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.ssh;
in
{
  options.my = {
    ssh.enable = lib.mkEnableOption "enable ssh config";
  };

  config = lib.mkIf cfg.enable {
    services.openssh.enable = true;
    programs.mosh.enable = true;
  };
}
