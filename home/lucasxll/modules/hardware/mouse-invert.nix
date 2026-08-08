# Scripts para controlar o serviço mouse-invert (definido em input-left-handed.nix).
#
# PORTADO niri → mango: "niri msg output X transform flipped" não existe no
# mango (não achei um dispatch de runtime equivalente na doc oficial —
# monitorrule=rr:N é só para o config estático). Troquei por `wlr-randr`,
# que é uma ferramenta padrão wlroots e funciona com qualquer compositor
# wlroots (incluindo mango) — mais portável que depender do IPC específico
# do compositor.

{ pkgs, ... }:

let
  outputName = "eDP-1";

  mangoMirror = pkgs.writeShellScriptBin "mango-mirror" ''
    set -e
    ${pkgs.wlr-randr}/bin/wlr-randr --output "${outputName}" --transform flipped
    echo "y" | sudo tee /run/mouse-invert-mode > /dev/null
    sudo systemctl restart mouse-invert
    echo "[mango-mirror] tela espelhada, mouse modo=y"
  '';

  mangoReset = pkgs.writeShellScriptBin "mango-reset" ''
    set -e
    ${pkgs.wlr-randr}/bin/wlr-randr --output "${outputName}" --transform normal
    echo "xy" | sudo tee /run/mouse-invert-mode > /dev/null
    sudo systemctl restart mouse-invert
    echo "[mango-reset] tela normal, mouse modo=xy"
  '';
in
{
  home.packages = [ mangoMirror mangoReset ];
}
