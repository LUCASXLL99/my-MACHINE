# home/lucasxll/modules/clipboard.nix
#
# CopyQ — histórico de clipboard unificado (niri + bspwm).
#   niri   → copyq show (atalho Mod+V em niri.nix)
#   bspwm  → copyq show (super+v em sxhkdrc)
#
# Para limpar histórico: copyq action
# Dados persistidos em ~/.local/share/copyq/

{ pkgs, ... }:

{
  home.packages = [ pkgs.copyq ];

  # Daemon: roda em background e captura clipboard automaticamente
  systemd.user.services.copyq = {
    Unit = {
      Description  = "CopyQ clipboard manager daemon";
      After        = [ "graphical-session.target" ];
      PartOf       = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart    = "${pkgs.copyq}/bin/copyq";
      Restart      = "on-failure";
      RestartSec   = "2s";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
