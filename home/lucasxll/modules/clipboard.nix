# home/lucasxll/modules/clipboard.nix
#
# CopyQ — histórico compartilhado entre sessões.
#   X11/bspwm  → nativo; atalho super+v em sxhkdrc
#   Wayland/niri → via xwayland-satellite (:1); Mod+V abre painel noctalia
#
# Histórico em ~/.local/share/copyq.

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
