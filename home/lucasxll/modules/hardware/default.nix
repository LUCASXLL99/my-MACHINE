{ config, pkgs, inputs, ... }:
{
  imports = [
    ./mouse-invert.nix
    ./display-mode.nix
  ];
}
