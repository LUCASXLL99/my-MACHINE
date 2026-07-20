{ pkgs, inputs, ... }:

# ATENÇÃO: este arquivo NÃO veio no zip original (só existia a pasta
# home/lucasxll/modules/x11 vazia). Este é um STUB mínimo só pra deixar
# o import do módulo do wezterm funcionando.
#
# Se você já tem um home/lucasxll/default.nix de verdade na sua máquina,
# NÃO substitua ele por este — apenas copie a linha abaixo pro seu
# array de `imports`:
#
#   ./modules/terminal/wezterm.nix

{
  imports = [
    ./modules/terminal/wezterm.nix
  ];

  home.stateVersion = "25.05";
}
