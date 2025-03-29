{ config, ... }:
{
  imports = [
    ./home.nix
    ../common
    ./packages
  ];
}
