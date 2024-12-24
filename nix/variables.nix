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
    hashedPassword = "8cd824c700eb0c125fff40c8c185d14c5dfe7f32814afac079ba7c20d93bc3c082193243c420fed22ef2474fbb85880e7bc1ca772150a1f759f8ddebca77711f";
    sshKeys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFZPZ+lDBETiLkDt5W7KqCwk67b2eTBbRqI923tjVhnS"];
  };
}
