{ config, lib, pkgs, ... }:

let
  cfg = config.my.pipewire;
in
{
  options.my = {
    pipewire.enable = lib.mkEnableOption "enable pipewire config";
  };

  config = lib.mkIf cfg.enable {
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    environment.systemPackages = with pkgs; [
      alsa-tools
      alsa-utils
    ];
  };
}
