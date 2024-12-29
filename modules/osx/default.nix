{ config, lib, pkgs, ... }:

{
  imports = [
    ./homebrew.nix
    ./trackpad.nix
  ];
}
