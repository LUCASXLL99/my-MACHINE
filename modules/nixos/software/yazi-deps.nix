# Deps de sistema para prévia do yazi (o yazi em si fica em home/lucasxll/modules/yazi.nix)

{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ffmpegthumbnailer  # vídeos
    unar               # arquivos comprimidos
    jq                 # JSON
    poppler_utils      # PDF
    imagemagick        # imagens
  ];
}
