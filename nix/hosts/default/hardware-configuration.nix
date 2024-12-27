{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ./video.nix ];

  fileSystems."/" = {
      device = "/dev/disk/by-uuid/8b1fa901-c05b-48c1-a961-a789620601d6";
      fsType = "btrfs";
      options = ["subvol=@" "compress=zstd"];
      neededForBoot = true;
    };

  fileSystems."/home" = {
      device = "/dev/disk/by-uuid/8b1fa901-c05b-48c1-a961-a789620601d6";
      fsType = "btrfs";
      options = ["subvol=@home" "compress=zstd"];
    };

  fileSystems."/nix" = {
      device = "/dev/disk/by-uuid/8b1fa901-c05b-48c1-a961-a789620601d6";
      fsType = "btrfs";
      options = ["subvol=@nix" "compress=zstd" "noatime"];
      neededForBoot = true;
    };

  fileSystems."/.snapshots" = {
      device = "/dev/disk/by-uuid/8b1fa901-c05b-48c1-a961-a789620601d6";
      fsType = "btrfs";
      options = ["subvol=@snapshots" "compress=zstd"];
    };

  fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/02fc10a5-c3f0-45c3-8766-95c9d84a4f60";
      fsType = "ext2";
    };

  fileSystems."/boot/efi" = {
      device = "/dev/disk/by-uuid/56F6-FFB4";
      fsType = "vfat";
    };

  swapDevices = [
    {
      device = "/dev/disk/by-uuid/d8b55c56-5a0e-4046-a4cf-097f95bfde6f";
    }
  ];

  boot.initrd.kernelModules = ["dm-snapshot" "btrfs"];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
