# home/lucasxll/default.nix
#
# SESSÕES
#   Niri  (Wayland) — PRINCIPAL
#   bspwm (X11)     — RESERVA / fallback
#
# Pacotes exclusivos de cada sessão ficam no módulo da sessão, não aqui.

{ config, pkgs, inputs, ... }:

{
  imports = [
    (inputs.noctalia.homeModules.default)

    # Aparência
    ./modules/stylix.nix
    ./modules/dolphin-nord.nix

    # X11 — bspwm (reserva)
    ./modules/bspwm.nix
    ./modules/polybar.nix
    ./modules/picom.nix
    ./modules/dunst.nix        # desativado automaticamente no niri via systemd

    # Wayland — niri (principal)
    ./modules/niri.nix
    ./modules/noctalia.nix
    # ./modules/screen-reflect.nix   # PAUSADO
    ./modules/mouse-invert.nix
    ./modules/hot-corner.nix   # canto superior direito → overview

    # Cross-session
    ./modules/terminals.nix
    ./modules/clipboard.nix
    ./modules/yazi.nix
    ./modules/lf.nix
    ./modules/neovim.nix
    ./modules/zsh.nix
    ./modules/files.nix        # MIME (Wayland)

    # Wallpaper
    ./modules/wallpaper.nix

    # Dev
    ./modules/coding-agents.nix
    ./modules/cargo-config.nix
  ];

  home.username      = "lucasxll";
  home.homeDirectory = "/home/lucasxll";
  home.stateVersion  = "25.05";

  programs.home-manager.enable = true;

  # Pacotes cross-session (exclusivos de X11 → bspwm.nix; Wayland → niri.nix)
  home.packages = with pkgs; [
    pavucontrol
    mpv
    imv             # viewer Wayland-nativo (X11 usa feh instalado em bspwm.nix)
    brightnessctl
    file-roller
    p7zip
    unrar
  ];

  fonts.fontconfig.enable = true;
}
