{ config, lib, pkgs, ... }:

{
  networking.hostName = config.hostname;
  networking.networkmanager.enable = true;
}
