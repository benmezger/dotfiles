{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.gnupg;
in
{
  config = lib.mkIf cfg.enable {
    programs.gnupg.agent.pinentryPackage = pkgs.pinentry-gtk2;
  };
}
