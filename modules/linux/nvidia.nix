{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.nvidia;
in
{
  options.my = {
    nvidia.enable = lib.mkEnableOption "enable nvidia config";
  };

  config = lib.mkIf cfg.enable {
    hardware.nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      open = true;
    };

    hardware.graphics.enable = true;
  };
}
