{
  config,
  lib,
  pkgs,
  userConf,
  ...
}:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "module_blacklist=i915"
      # set HID_QUIRK_ALWAYS_POLL for Razer Basilisk V3 Pro mouse
      # to prevent connection drop
      # fixes: usb 1-10.2: 3:1: cannot get freq at ep 0x3
      "usbhid.quirks=0x1532:0x00ab:0x00000400"
      "ip=192.168.0.168::192.168.0.1:255.255.255.0:${userConf.hostname}.local::none"
    ];
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
      systemd.users.root.shell = "/bin/cryptsetup-askpass";
      network = {
        enable = true;
        ssh = {
          enable = true;
          port = 22;
          authorizedKeys = userConf.sshKeys;
          hostKeys = [ "/etc/secrets/initrd/host_rsa_key" ];
        };
      };
      availableKernelModules = [
        "vmd"
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
        "igc"
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
