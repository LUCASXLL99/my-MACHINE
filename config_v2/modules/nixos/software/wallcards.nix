# Deps de sistema para o plugin Wallcards do Noctalia (wallpaper em vídeo).
# Instalar: git clone https://github.com/noctalia-dev/noctalia-plugins /tmp/np
#           cp -r /tmp/np/wallcards ~/.config/noctalia/plugins/wallcards

{ pkgs, ... }:

{ environment.systemPackages = [ pkgs.mpvpaper ]; }
