# home/lucasxll/modules/clipboard.nix
# CopyQ — histórico de clipboard compartilhado entre sessões.
#
# COMPORTAMENTO POR SESSÃO
# ─────────────────────────
#   X11 / bspwm  → copyq roda como processo X11 nativo.
#                  Atalho: super+v  (definido em bspwm.nix/sxhkdrc)
#
#   Wayland / niri → copyq roda via xwayland-satellite (:1).
#                    Atalho: Mod+V abre o painel do noctalia, que lê
#                    o histórico do copyq por baixo dos panos.
#                    A window-rule "copyq → open-floating" em niri.nix
#                    garante que a janela flutue quando chamada.
#
# O histórico é compartilhado entre as duas sessões via ~/.local/share/copyq.

{ pkgs, ... }:

{
  home.packages = [ pkgs.copyq ];

  xdg.configFile."copyq/copyq.conf".text = ''
    [General]
    maxitems=100
    saveImagesOnClose=false
    viMode=false
    closeOnUnfocus=true

    [Shortcuts]
    activate_closes=true
  '';
}
