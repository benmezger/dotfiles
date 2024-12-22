{ config, pkgs, lib, ... }:

{
  options = with lib; with types; {
    username = mkOption { type = str; };
    hostname = mkOption { type = str; };
    timezone = mkOption { type = str; };
    locale = mkOption { type = str; };
    locale_settings = mkOption { type = attrs; };
  };
  config = {
    username = "seds";
    hostname = "lenin";
    timezone = "Europe/Amsterdam";
    locale = "en_US.UTF-8";
    locale_settings = {
      LC_ADDRESS = "nl_NL.UTF-8";
      LC_IDENTIFICATION = "nl_NL.UTF-8";
      LC_MEASUREMENT = "nl_NL.UTF-8";
      LC_MONETARY = "nl_NL.UTF-8";
      LC_NAME = "nl_NL.UTF-8";
      LC_NUMERIC = "nl_NL.UTF-8";
      LC_PAPER = "nl_NL.UTF-8";
      LC_TELEPHONE = "nl_NL.UTF-8";
      LC_TIME = "nl_NL.UTF-8";
    };
  };
}
