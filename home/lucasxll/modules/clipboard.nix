# home/lucasxll/modules/clipboard.nix
#
# cliphist — histórico de clipboard nativo Wayland.
#   niri   → cliphist + fuzzel (Wayland-nativo); atalho Mod+V em niri.nix
#   bspwm  → CopyQ (instalado em bspwm.nix, super+v em sxhkdrc)
#
# Histórico persistido em ~/.cache/cliphist/db.
# Para limpar: cliphist wipe

{ pkgs, ... }:

{
  home.packages = [ pkgs.cliphist pkgs.fuzzel ];

  # Daemon: assiste wl-paste e alimenta o banco do cliphist
  systemd.user.services.cliphist = {
    Unit = {
      Description  = "Clipboard history daemon (Wayland)";
      After        = [ "graphical-session.target" ];
      PartOf       = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart    = "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store";
      Restart      = "on-failure";
      RestartSec   = "2s";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # Também captura imagens (opcional — comentar se não quiser)
  systemd.user.services.cliphist-img = {
    Unit = {
      Description  = "Clipboard image history daemon (Wayland)";
      After        = [ "graphical-session.target" ];
      PartOf       = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart    = "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${pkgs.cliphist}/bin/cliphist store";
      Restart      = "on-failure";
      RestartSec   = "2s";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
