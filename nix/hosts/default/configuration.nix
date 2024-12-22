# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, inputs, outputs, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./networking.nix
      ./bootloader.nix
      ./x.nix
      ./../../variables.nix
      inputs.home-manager.nixosModules.home-manager
    ];

  services.openssh.enable = true;

  time.timeZone = config.timezone;

  i18n.defaultLocale = config.locale;
  i18n.extraLocaleSettings = config.locale_settings;

  users.users = {
    "${config.username}"= {
      isNormalUser = true;
      initialPassword = "12345";
      extraGroups = [
        "networkmanager"
        "wheel"
        "audio"
        "video"
        "plugdev"
        "input"
      ];
      packages = [ inputs.home-manager.packages.${pkgs.system}.default ];
    };
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users."${config.username}" = import (builtins.toPath ../../home/default/default.nix);
  };

  # Install firefox.
  programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    git
    ripgrep
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
