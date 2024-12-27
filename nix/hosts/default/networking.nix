{ config, lib, pkgs, ... }:

{
  networking.hostName = config.hostname;
  networking.networkmanager.enable = true;

  networking.useDHCP = lib.mkDefault true;
  networking.nameservers = ["1.1.1.3" "1.0.0.3"];

}
