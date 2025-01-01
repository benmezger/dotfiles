{
  userConf,
  config,
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    inputs.home-manager.darwinModules.home-manager
  ];

  time.timeZone = userConf.timezone;

  my.fonts.enable = true;
  my.gnupg.enable = true;
  my.homebrew.enable = true;
  my.trackpad.enable = true;

  homebrew.brews = [
    "ripgrep"
    "terraform"
    "tmux"
    "tig"
    "tree"
    "watch"
    "wakatime-cli"
    "weechat"
    "vim"
    "zsh"
    "isync"
    "mu"
    "htop"
    "chezmoi"
    "reattach-to-user-namespace"
  ];

  homebrew.casks = [
    "1password-cli"
    "1password"
    "alacritty"
    "basictex"
    "docker"
    "insomnia"
    "maccy"
    "sloth"
    "spotify"
    "telegram"
    "transmission"
    "firefox"
    "numi"
    "whatsapp"
    "slack"
    "discord"
  ];

  homebrew.taps = [
    "d12frosted/emacs-plus"
    "homebrew/bundle"
    "homebrew/cask-fonts"
    "discoteq/discoteq"
    "koekeishiya/formulae"
  ];

  users.users = {
    "${userConf.osx_username}" = {
      home = "/Users/${userConf.osx_username}";
      shell = pkgs.bashInteractive;
      ignoreShellProgramCheck = true;
      openssh.authorizedKeys.keys = userConf.sshKeys;
      packages = [ inputs.home-manager.packages.${pkgs.system}.default ];
    };
  };

  nix = {
    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 0;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };
    optimise.automatic = true;
  };

  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}
