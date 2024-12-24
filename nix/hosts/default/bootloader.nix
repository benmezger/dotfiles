{ config, lib, pkgs, ... }:

{
  boot = {
    supportedFilesystems = ["btrfs"];
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        useOSProber = true;
        enable = true;
        device = "nodev";
        efiSupport = true;
        enableCryptodisk = true;
      };
    };
    initrd.luks.devices = {
      cryptroot = {
        # Use https://nixos.wiki/wiki/Full_Disk_Encryption
        device = "/dev/disk/by-uuid/d4dd9554-893b-40c3-b81e-1fbf38e81392";
        preLVM = true;
      };
    };
    initrd.postDeviceCommands = lib.mkAfter ''
        mkdir /mnt
        mount -t btrfs /dev/mapper/enc /mnt
        btrfs subvolume delete /mnt/root
        btrfs subvolume snapshot /mnt/root-blank /mnt/root
      '';
  };
}
