# home/lucasxll/modules/mouse-invert.nix
#
# Scripts niri-mirror e niri-reset que controlam o serviço SISTEMA
# mouse-invert.service (definido em input-left-handed.nix).
#
# A inversão roda como serviço de sistema (root) para cobrir SDDM e niri.
# Os scripts usam sudo para trocar o modo (y ↔ xy) via arquivo de estado.

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
  # Serviços de usuário removidos — mouse-invert agora é serviço de sistema
  # definido em modules/nixos/hardware/input.nix
}
