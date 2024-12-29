{ userConf, config, lib, pkgs, ... }:

let
  cfg = config.my._1password;
in
{
  options.my = {
    _1password.enable = lib.mkEnableOption "enable 1Password config";
  };

  config = lib.mkIf cfg.enable {
    programs._1password.enable = true;
    programs._1password-gui = {
      enable = true;
      polkitPolicyOwners = [userConf.username];
    };

    environment.systemPackages = with pkgs; [
      _1password-gui
      _1password-cli
    ];
  };
}
