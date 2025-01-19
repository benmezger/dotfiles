{
  userConf,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.networking;
in
{
  options.my = {
    networking.enable = lib.mkEnableOption "enable networking config";
  };

  config = lib.mkIf cfg.enable {
    networking.hostName = userConf.hostname;
    networking.networkmanager.enable = true;

    networking.useDHCP = lib.mkDefault true;
    networking.nameservers = [
      "1.1.1.3"
      "1.0.0.3"
    ];

    environment.systemPackages = with pkgs; [
      nettools
      dhcpcd
    ];

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
      };
    };
  };
}
