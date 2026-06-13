# home/lucasxll/modules/clipboard.nix
# cliphist — histórico de clipboard nativo Wayland.
#   niri   → cliphist + fuzzel (Mod+V em niri.nix)
#   bspwm  → CopyQ (bspwm.nix / super+v em sxhkdrc)
#
# Histórico em ~/.cache/cliphist/db. Para limpar: cliphist wipe

{ pkgs, ... }:

{
  home.packages = [ pkgs.cliphist pkgs.fuzzel ];

  systemd.user.services.cliphist = {
    Unit = {
      Description  = "Clipboard history — texto (Wayland)";
      After        = [ "graphical-session.target" ];
      PartOf       = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart  = "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store";
      Restart    = "on-failure";
      RestartSec = "2s";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # Captura imagens no histórico (comentar se não quiser)
  systemd.user.services.cliphist-img = {
    Unit = {
      Description  = "Clipboard history — imagens (Wayland)";
      After        = [ "graphical-session.target" ];
      PartOf       = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart  = "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${pkgs.cliphist}/bin/cliphist store";
      Restart    = "on-failure";
      RestartSec = "2s";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
