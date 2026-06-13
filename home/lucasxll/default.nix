{ config, pkgs, inputs, ... }:

{
  imports = [
    (inputs.noctalia.homeModules.default)

    ./modules/stylix.nix
    ./modules/dolphin-nord.nix

    ./modules/bspwm.nix
    ./modules/polybar.nix
    ./modules/picom.nix
    ./modules/dunst.nix

    ./modules/niri.nix
    ./modules/noctalia.nix
    ./modules/mouse-invert.nix
    ./modules/hot-corner.nix

    ./modules/terminals.nix
    ./modules/clipboard.nix
    ./modules/yazi.nix
    ./modules/lf.nix
    ./modules/neovim.nix
    ./modules/zsh.nix
    ./modules/files.nix

    ./modules/wallpaper.nix

    ./modules/coding-agents.nix
    ./modules/cargo-config.nix
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
