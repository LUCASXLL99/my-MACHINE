# nixos-Modules/Modules-Hardware/screen-reflect-x.nix
#
# Espelha a tela horizontalmente (--reflect x) em todos os monitores
# conectados, logo no início da sessão X.
#
# ATIVAR:    descomentar o import no configuration.nix + rebuild
# DESATIVAR: comentar o import no configuration.nix + rebuild

{ pkgs, ... }:

{
  services.xserver.displayManager.sessionCommands = ''
    # Espelha horizontalmente todos os monitores conectados
    for output in $(${pkgs.xorg.xrandr}/bin/xrandr | awk '/ connected/{print $1}'); do
      ${pkgs.xorg.xrandr}/bin/xrandr --output "$output" --reflect x || true
    done
  '';
}
