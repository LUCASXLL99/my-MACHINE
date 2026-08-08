# CopyQ — histórico de clipboard unificado (mango + bspwm).
# mango → Mod+V (mango.nix) | bspwm → super+v (sxhkdrc)

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
