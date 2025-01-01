{
  config,
  lib,
  pkgs,
  ...
}:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "module_blacklist=i915" ];
    supportedFilesystems = [ "btrfs" ];
    kernelModules = [
      "kvm-intel"
      "iwlwifi"
    ];
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
    initrd = {
      availableKernelModules = [
        "vmd"
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      luks.devices = {
        cryptroot = {
          # Use https://nixos.wiki/wiki/Full_Disk_Encryption
          device = "/dev/disk/by-uuid/d4dd9554-893b-40c3-b81e-1fbf38e81392";
          preLVM = true;
        };
      };
    };
    kernel = {
      sysctl = {
        "kernel.dmesg_restrict" = 0;
      };
    };
  };
}
