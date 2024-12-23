{ config, lib, pkgs, ... }:

{
  home.activation.setupDoomEmacs = lib.hm.dag.entryAfter ["writeBoundary"] ''
    export PATH=${pkgs.git}/bin:$PATH
    export PATH=${pkgs.emacs}/bin:$PATH

    # Clone Doom Emacs repository if it doesn't exist
    if [ ! -d ~/.config/emacs ]; then
      git clone --depth 1 https://github.com/doomemacs/doomemacs.git ~/.config/emacs
    fi

    # Run Doom Emacs installation script
    ~/.config/emacs/bin/doom install --force
  '';

  home.activation.setupDotfiles = lib.hm.dag.entryAfter ["writeBoundary"] ''
    export PATH=${pkgs.git}/bin:$PATH

    # Clone dotfiles repository if it doesn't exist
    if [ ! -d ~/dotfiles ]; then
      git clone --depth 1 https://github.com/benmezger/dotfiles.git ~/dotfiles
    fi
  '';
}
