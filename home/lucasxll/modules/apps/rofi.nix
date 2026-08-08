# Rofi: habilita o módulo do home-manager para o tema do Stylix aplicar
# (stylix.targets.rofi gera o config.rasi com o Tokyo Night).
# O pacote rofi já vem do sistema (modules/nixos/system/packages.nix);
# usar o mesmo pkgs.rofi aqui não duplica no store (mesmo path).

{ pkgs, ... }:

{
  programs.rofi = {
    enable  = true;
    package = pkgs.rofi;
  };
}
