{ config, lib, pkgs, ... }:

{
  # Enable the NVIDIA drivers
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    package = pkgs.nvidiaPackages.latest;
  };

  hardware.opengl.enable = true;

  boot.extraModulePackages = [
    config.boot.kernelPackages.nvidia_x11
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
}
