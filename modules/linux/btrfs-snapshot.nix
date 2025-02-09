{
  config,
  lib,
  pkgs,
  userConf,
  ...
}:

let
  cfg = config.my.btrfsSnapshot;
in
{
  options.my = {
    btrfsSnapshot.enable = lib.mkEnableOption "enable btrfs snapshot service";
  };

  config = lib.mkIf cfg.enable {
    systemd.services."btrfs-snapshot" = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      description = "Start btrfs-snapshot script.";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = ''/home/${userConf.username}/.bin/btrfs-snapshot'';
      };
    };

    systemd.timers."btrfs-snapshot" = {
      enable = true;
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "2m";
        OnUnitActiveSec = "6h";
        Unit = "btrfs-snapshot.service";
      };
    };
  };
}
