{ config, lib, pkgs, ... }:

{
  # Enable the NVIDIA drivers

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.opengl.enable = true;
}
