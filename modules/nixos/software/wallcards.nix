# modules/nixos/software/wallcards.nix
#
# Deps de sistema para o plugin Wallcards do Noctalia (wallpaper em vídeo).
#
# Instalar o plugin (uma vez):
#   git clone https://github.com/noctalia-dev/noctalia-plugins /tmp/np
#   cp -r /tmp/np/wallcards ~/.config/noctalia/plugins/wallcards
#
# Vídeos em ~/Pictures/wallpapers/. Atalho: Mod+Shift+W.

{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.mpvpaper ];
}
