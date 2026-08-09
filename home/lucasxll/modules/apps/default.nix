{ config, pkgs, inputs, ... }:
{
  imports = [
    ./neovim.nix
    ./yazi.nix
    ./lf.nix
    ./rofi.nix
    ./coding-agents.nix
    ./fastfetch.nix
  ];
}
