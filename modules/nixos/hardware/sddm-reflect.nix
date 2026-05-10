# modules/nixos/hardware/sddm-reflect.nix
#
# SDDM — espelhamento de tela no greeter.
#
# Tema visual removido (sddm-chili era Qt5 e o SDDM no nixpkgs-25.05
# usa Qt6 — a mistura causava erro "mismatched Qt dependencies" na build).
# O tema padrão do SDDM é usado por ora.
# Para adicionar tema no futuro: usar apenas temas Qt6-nativos
# (ex: pkgs.where-is-my-sddm-theme, se disponível no canal usado).

{ pkgs, ... }:

{
  services.displayManager.sddm = {
    enable = true;

    # Roda antes do greeter aparecer — espelha a tela horizontalmente
    setupScript = ''
      for output in $(${pkgs.xorg.xrandr}/bin/xrandr | ${pkgs.gawk}/bin/awk '/ connected/{print $1}'); do
        ${pkgs.xorg.xrandr}/bin/xrandr --output "$output" --reflect x
      done
    '';
  };
}
