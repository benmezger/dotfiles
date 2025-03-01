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

    services.udev.extraRules = ''
      SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="e8:9c:25:38:4e:a0", NAME="eth0"
      SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="90:09:df:57:fe:4a", NAME="wlan0"
    '';

    networking.interfaces."eth0" = {
      name = "eth0";
      macAddress = "e8:9c:25:38:4e:a0";
      wakeOnLan.enable = true;
    };

    networking.interfaces."wlan0" = {
      name = "wlan0";
      macAddress = "90:09:df:57:fe:4a";
      wakeOnLan.enable = true;
    };

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

    services.blueman.enable = true;
    hardware.bluetooth = {
      enable = true;
    };
  };
}
