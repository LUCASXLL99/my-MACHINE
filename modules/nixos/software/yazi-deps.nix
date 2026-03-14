# modules/nixos/software/yazi-deps.nix
# Dependências de sistema para o yazi (prévia de imagens, vídeos, PDF)
# O yazi em si é gerenciado pelo home manager (home/lucasxll/modules/yazi.nix)

{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ffmpegthumbnailer  # prévia de vídeos
    unar               # extração universal
    jq                 # prévia de JSON
    poppler_utils      # prévia de PDF
    imagemagick        # prévia e conversão de imagens
  ];
}
