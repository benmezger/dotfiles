# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  userConf,
  config,
  inputs,
  outputs,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./bootloader.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  my = {
    x.enable = true;
    networking.enable = true;
    pipewire.enable = true;
    locate.enable = true;
    ssh.enable = true;
    clipboard.enable = true;
    gnome.enable = true;
    grub.enable = true;
    gnupg.enable = true;
    _1password.enable = true;
    dconf.enable = true;
    fonts.enable = true;
    fwupd.enable = true;
    thunar.enable = true;
    syncmail.enable = true;
  };

  time.timeZone = userConf.timezone;
  i18n.defaultLocale = userConf.locale;
  i18n.extraLocaleSettings = userConf.locale_settings;

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    settings = {
      auto-optimise-store = true;
    };
  };

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

  environment.systemPackages = with pkgs; [
    vim
    git
    ripgrep
    acpi
    acpid
    autoconf
    binutils
    bzip2
    coreutils
    cryptsetup
    findutils
    gcc
    libgcc
    gnugrep
    less
    lvm2
    gnumake
    man
    gnused
    gnutar
    which
    iucode-tool
    upower
    nixfmt-rfc-style
    nix-index
  ];

  environment.variables.LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    glibc
  ];

  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
    enableOnBoot = false;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
