{ config, pkgs, inputs, ... }:
{
  imports = [
    ./bspwm.nix
    ./picom.nix
    ./dunst.nix
    ./polybar.nix
    ./screen-reflect.nix
  ];
}
