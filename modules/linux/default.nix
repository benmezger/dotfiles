{ userConf, config, lib, pkgs, ... }:

{
  imports = [
    ./x.nix
    ./networking.nix
    ./nvidia.nix
    ./pipewire.nix
    ./greenclip.nix
    ./gnome.nix
    ./grub.nix
  ];
}
