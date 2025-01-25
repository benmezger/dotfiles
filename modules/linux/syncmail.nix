{
  config,
  lib,
  pkgs,
  userConf,
  ...
}:

let
  cfg = config.my.syncmail;
in
{
  options.my = {
    syncmail.enable = lib.mkEnableOption "enable syncmail config";
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services."syncmail" = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      description = "Start syncmail script.";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = ''${pkgs.zsh}/bin/zsh -c -i syncmail'';
      };
    };

    systemd.user.timers."syncmail" = {
      enable = true;
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "2m";
        OnUnitActiveSec = "15m";
        Unit = "syncmail.service";
      };
    };
  };
}
