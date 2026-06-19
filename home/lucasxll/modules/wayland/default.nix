{ config, pkgs, inputs, ... }:
{
  imports = [
    ./niri.nix
    ./noctalia.nix
    ./wallpaper.nix
    ./hot-corner.nix
    ./clipboard.nix
  ];
}
