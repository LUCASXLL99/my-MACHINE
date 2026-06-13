# CopyQ — histórico de clipboard unificado (niri + bspwm).
# niri → Mod+V (niri.nix) | bspwm → super+v (sxhkdrc)

{ pkgs, ... }:

{
  home.packages = [ pkgs.copyq ];

  systemd.user.services.copyq = {
    Unit = {
      Description = "CopyQ clipboard manager";
      After        = [ "graphical-session.target" ];
      PartOf       = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart  = "${pkgs.copyq}/bin/copyq";
      Restart    = "on-failure";
      RestartSec = "2s";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
