# home/lucasxll/modules/clipboard.nix
# CopyQ — histórico compartilhado entre sessões.
#   X11:     roda nativo; atalho super+v em bspwm.nix
#   Wayland: roda via xwayland-satellite (:1); Mod+V abre painel noctalia

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
