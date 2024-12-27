{ config, lib, pkgs, ... }:

{
  services.openssh.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.locate.enable = true;

}
