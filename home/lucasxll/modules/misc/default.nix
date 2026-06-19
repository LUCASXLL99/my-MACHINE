{ config, pkgs, inputs, ... }:
{
  imports = [
    ./files.nix
    ./cargo-config.nix
  ];
}
