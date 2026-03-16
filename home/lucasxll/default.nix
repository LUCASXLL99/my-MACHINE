# home/lucasxll/default.nix
# Entrada do Home Manager para o usuário lucasxll
# Importa todos os módulos do usuário separadamente

{ config, pkgs, inputs, ... }:

{
  imports = [
    ./modules/terminals.nix
    ./modules/screen-reflect.nix
    ./modules/bspwm.nix
    ./modules/polybar.nix
    ./modules/picom.nix
    ./modules/dunst.nix
    ./modules/gammastep.nix
    ./modules/clipboard.nix
    ./modules/yazi.nix
    ./modules/zsh.nix
    ./modules/files.nix      # gerenciadores de arquivo
  ];

  home.username      = "lucasxll";
  home.homeDirectory = "/home/lucasxll";
  home.stateVersion  = "25.05";

  programs.home-manager.enable = true;

  # Pacotes gerais do usuário
  home.packages = with pkgs; [
    keepassxc
    seahorse
    pavucontrol
    feh
    flameshot
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-volman
    xfce.tumbler
    file-roller p7zip unrar
  ];

  fonts.fontconfig.enable = true;
}
