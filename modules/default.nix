{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./fonts.nix
    ./gnupg.nix
  ];
}
