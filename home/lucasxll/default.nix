{ config, pkgs, inputs, ... }:
{
  imports = [
    (inputs.noctalia.homeModules.default)
    ./modules/appearance
    ./modules/x11
    ./modules/wayland
    ./modules/shell
    ./modules/apps
    ./modules/hardware
    ./modules/misc
  ];
  home.username      = "lucasxll";
  home.homeDirectory = "/home/lucasxll";
  home.stateVersion  = "25.05";
  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    pavucontrol
    mpv
    imv
    brightnessctl
    file-roller
    p7zip
    unrar
  ];
  fonts.fontconfig.enable = true;
}
