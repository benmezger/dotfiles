# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ userConf, config, inputs, outputs, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./networking.nix
      ./bootloader.nix
      ./x.nix
      ./apps.nix
      inputs.home-manager.nixosModules.home-manager
    ];

  time.timeZone = userConf.timezone;

  i18n.defaultLocale = userConf.locale;
  i18n.extraLocaleSettings = userConf.locale_settings;

  users.users = {
    "${userConf.username}" = {
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
        "audio"
        "video"
        "plugdev"
        "input"
        "power"
      ];
      shell = pkgs.zsh;
      ignoreShellProgramCheck = true;

      hashedPassword = userConf.hashedPassword;
      openssh.authorizedKeys.keys = userConf.sshKeys;
      packages = [ inputs.home-manager.packages.${pkgs.system}.default ];
    };
  };


  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users."${userConf.username}" = import (builtins.toPath ../../home/default/default.nix);
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    git
    ripgrep
    acpi
    acpid
    alsa-tools
    alsa-utils
    autoconf
    binutils
    bzip2
    coreutils
    cryptsetup
    dhcpcd
    findutils
    gcc
    libgcc
    gnugrep
    less
    lvm2
    gnumake
    man
    mlocate
    nettools
    gnused
    gnutar
    which
    iucode-tool
    refind
    gnome-keyring
    _1password-gui
    _1password-cli
    upower
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-gtk2;
  };

  # https://discourse.nixos.org/t/findutils-missing-locate-and-updatedb/27557/4
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [userConf.username];
  };

  programs.dconf.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    glibc
  ];

  fonts.packages = [
    pkgs.nerd-fonts.hack
    pkgs.font-awesome
    pkgs.noto-fonts-emoji-blob-bin
    pkgs.source-code-pro
    pkgs.hack-font
  ];

  fonts.fontconfig.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
