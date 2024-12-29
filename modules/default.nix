{ config, lib, pkgs, ... }:

{
  imports = [
    ./linux
    ./locate.nix
    ./ssh.nix
    ./gnupg.nix
    ./1password.nix
    ./dconf.nix
    ./fonts.nix
  ];
}
