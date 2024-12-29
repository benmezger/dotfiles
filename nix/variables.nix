{ config, pkgs, lib, ... }:

{
  options = with lib; with types; {
    username = mkOption { type = str; };
    hostname = mkOption { type = str; };
    timezone = mkOption { type = str; };
    locale = mkOption { type = str; };
    locale_settings = mkOption { type = attrs; };
    hashedPassword = mkOption { type = str; };
    sshKeys = mkOption { type = types.listOf str; };
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
    hashedPassword = "$y$j9T$9e8lY.GFRO4g7B9XhJat41$cZ7f/BHb9WzvE1BwKZJTQwrram/8ZfgT.jYCX90acHA";
    sshKeys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFZPZ+lDBETiLkDt5W7KqCwk67b2eTBbRqI923tjVhnS"];
  };
}
