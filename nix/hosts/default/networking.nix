{ config, lib, pkgs, ... }:

{
  networking.hostName = config.hostname;
  networking.networkmanager.enable = true;

  networking.useDHCP = lib.mkDefault true;
}
