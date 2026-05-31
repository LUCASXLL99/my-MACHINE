# modules/nixos/software/wallcards.nix
# Dependências de sistema para o plugin Wallcards do Noctalia (wallpaper em vídeo).
#
# Instalar o plugin (uma vez):
#   git clone https://github.com/noctalia-dev/noctalia-plugins /tmp/np
#   cp -r /tmp/np/wallcards ~/.config/noctalia/plugins/wallcards

{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    mpvpaper  # renderiza vídeos na camada de fundo (ffmpeg/imagemagick via yazi-deps.nix)
  ];
}
