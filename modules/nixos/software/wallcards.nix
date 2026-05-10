# modules/nixos/software/wallcards.nix
#
# Dependências de sistema para o plugin Wallcards do Noctalia.
# O Wallcards adiciona suporte a vídeo como wallpaper (via mpvpaper)
# com um seletor visual de cards com preview ao vivo.
#
# Após o rebuild, instale o plugin manualmente (feito uma vez):
#   mkdir -p ~/.config/noctalia/plugins
#   git clone https://github.com/noctalia-dev/noctalia-plugins /tmp/noctalia-plugins
#   cp -r /tmp/noctalia-plugins/wallcards ~/.config/noctalia/plugins/wallcards
#
# O atalho Mod+Shift+W abre/fecha o seletor (declarado em niri.nix).
# Vídeos devem ficar em ~/Pictures/wallpapers/ junto com as imagens.

{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # mpvpaper: toca vídeos como wallpaper no Wayland.
    # O Wallcards usa mpvpaper internamente para renderizar vídeos
    # na camada de fundo — sem ele vídeos não funcionam.
    # ffmpeg e imagemagick já vêm do yazi-deps.nix.
    mpvpaper
  ];
}
