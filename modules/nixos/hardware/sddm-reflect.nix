# modules/nixos/hardware/sddm-reflect.nix
# Espelha a tela no SDDM (antes do login)
# Roda antes do display manager iniciar

{ pkgs, ... }:

{
  services.displayManager.sddm = {
    enable = true;
    # Script que roda antes do SDDM aparecer
    setupScript = ''
      for output in $(${pkgs.xorg.xrandr}/bin/xrandr | ${pkgs.gawk}/bin/awk '/ connected/{print $1}'); do
        ${pkgs.xorg.xrandr}/bin/xrandr --output "$output" --reflect x
      done
    '';
  };
}
