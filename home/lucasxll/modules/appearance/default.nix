{ config, pkgs, inputs, ... }:
{
  imports = [
    ./stylix.nix
    ./dolphin-nord.nix
    ./nightlight.nix
  ];
}
