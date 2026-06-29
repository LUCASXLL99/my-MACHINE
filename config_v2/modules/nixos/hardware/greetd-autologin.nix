{ config, pkgs, lib, ... }:

{
  services.greetd = {
    enable  = true;
    restart = false;
    settings = rec {
      initial_session = {
        command = "${config.programs.niri.package}/bin/niri-session";
        user    = "lucasxll";
      };
      default_session = initial_session;
    };
  };

  security.pam.services.greetd = {};

  systemd.services.display-manager.enable = lib.mkForce false;
}
