{
  userConf,
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./x.nix
    ./networking.nix
    ./nvidia.nix
    ./pipewire.nix
    ./greenclip.nix
    ./gnome.nix
    ./grub.nix
    ./1password.nix
    ./dconf.nix
    ./locate.nix
    ./ssh.nix
    ./fonts.nix
    ./gnupg.nix
    ./fwupd.nix
  ];
}
