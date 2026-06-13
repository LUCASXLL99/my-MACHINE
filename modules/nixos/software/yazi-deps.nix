# Deps de sistema para prévia do yazi (yazi em si: home/lucasxll/modules/yazi.nix).

{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ffmpegthumbnailer
    unar
    jq
    poppler_utils
    imagemagick
  ];
}
