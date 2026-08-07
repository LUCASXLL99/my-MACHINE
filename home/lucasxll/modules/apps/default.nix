{ config, pkgs, inputs, ... }:
{
  imports = [
    ./neovim.nix
    ./yazi.nix
    ./lf.nix
    ./coding-agents.nix
    ./espanso.nix
  ];
}
