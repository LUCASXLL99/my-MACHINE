# home/lucasxll/modules/mouse-invert.nix
#
# Scripts que controlam o serviço SISTEMA mouse-invert.service
# (definido em input-left-handed.nix).

{ pkgs, ... }:

let
  outputName = "eDP-1";

  niriMirror = pkgs.writeShellScriptBin "niri-mirror" ''
    set -e
    niri msg output "${outputName}" transform flipped
    echo "y" | sudo tee /run/mouse-invert-mode > /dev/null
    sudo systemctl restart mouse-invert
    echo "[niri-mirror] tela espelhada, mouse modo=y"
  '';

  niriReset = pkgs.writeShellScriptBin "niri-reset" ''
    set -e
    niri msg output "${outputName}" transform normal
    echo "xy" | sudo tee /run/mouse-invert-mode > /dev/null
    sudo systemctl restart mouse-invert
    echo "[niri-reset] tela normal, mouse modo=xy"
  '';

in
{
  home.packages = [ niriMirror niriReset ];
}
