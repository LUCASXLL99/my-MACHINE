{ config, pkgs, inputs, ... }:

{
  imports = [
    (inputs.noctalia.homeModules.default)

    ./modules/theme/stylix.nix
    ./modules/theme/dolphin-nord.nix
    ./modules/theme/terminals.nix

    ./modules/wayland/niri.nix
    ./modules/wayland/noctalia.nix
    ./modules/wayland/wallpaper.nix
    ./modules/wayland/hot-corner.nix
    ./modules/wayland/nightlight.nix

    ./modules/x11/bspwm.nix
    ./modules/x11/polybar.nix
    ./modules/x11/picom.nix
    ./modules/x11/dunst.nix

    ./modules/dev/neovim.nix
    ./modules/dev/cargo-config.nix
    ./modules/dev/coding-agents.nix

    ./modules/cli/zsh.nix
    ./modules/cli/lf.nix
    ./modules/cli/yazi.nix

    ./modules/system/files.nix
    ./modules/system/clipboard.nix
    ./modules/system/mouse-invert.nix
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
