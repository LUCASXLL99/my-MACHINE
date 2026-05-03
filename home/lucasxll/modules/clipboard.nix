# home/lucasxll/modules/clipboard.nix
# CopyQ — histórico de clipboard com interface gráfica
# super + v abre a janela do copyq diretamente

{ pkgs, ... }:

{
  home.packages = [ pkgs.copyq ];

  # Configuração do copyq: histórico de 100 itens, sem imagens
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
