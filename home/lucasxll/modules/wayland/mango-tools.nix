# ─────────────────────────────────────────────────────────────────────────
# mango-tools.nix — Scripts úteis portados de
# https://codeberg.org/theblackdon/mango-fedora (dotfiles/mango/bin).
#
# Só portei o que faz sentido pra programação/NixOS (nada de gaming/Steam/
# DualSense). Adaptações pro mango+NixOS:
#   - reload.sh: `mmsg dispatch reload_config` (mango é reload_config, não -d)
#   - screenshot.sh: mesmo grim+slurp+wl-copy, só com notify-send
#   - toggle-outer-gaps.sh → mango-toggle-gaps: em vez de sed no arquivo,
#     usa `mmsg dispatch setoption gappoh <valor>` (runtime, sem reescrever
#     config). Útil pra modo "gravação" (OBS) com gaps grandes.
#
# O binário mmsg vive no pacote do mango (flake mangowm/mango), que já vem
# como wayland.windowManager.mango.package — reaproveitamos o caminho aqui.
# ─────────────────────────────────────────────────────────────────────────

{ config, pkgs, ... }:

let
  mangoPkg = config.wayland.windowManager.mango.package;
  mmsg = "${mangoPkg}/bin/mmsg";
in
{
  home.packages = [
    (pkgs.writeShellScriptBin "mango-reload" ''
      set -e
      ${mmsg} dispatch reload_config
      notify-send "Mango" "Config recarregada"
    '')

    (pkgs.writeShellScriptBin "mango-screenshot" ''
      set -e
      FILE="$HOME/Pictures/screenshot_$(date +%Y%m%d_%H%M%S).png"
      ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" "$FILE" \
        && ${pkgs.wl-clipboard}/bin/wl-copy < "$FILE" \
        && notify-send "Screenshot" "Salva e copiada: $FILE"
    '')

    # Alterna gappoh entre 10 (normal) e 300 (modo gravação/OBS), em runtime.
    (pkgs.writeShellScriptBin "mango-toggle-gaps" ''
      set -e
      STATE="$HOME/.cache/mango-gaps-mode"
      if [ -f "$STATE" ]; then
        ${mmsg} dispatch setoption,gappoh,10
        rm -f "$STATE"
        notify-send "Gaps" "Normal (10px)"
      else
        ${mmsg} dispatch setoption,gappoh,300
        touch "$STATE"
        notify-send "Gaps" "Modo gravação (300px)"
      fi
    '')
  ];
}
