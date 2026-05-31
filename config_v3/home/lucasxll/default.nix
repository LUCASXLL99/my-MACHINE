# home/lucasxll/default.nix — entrada do Home Manager para lucasxll
#
# Sessões: niri (Wayland, principal) | bspwm (X11, fallback)
# Pacotes exclusivos de cada sessão ficam no módulo da sessão, não aqui.

{ config, pkgs, inputs, ... }:

{
  imports = [
    (inputs.noctalia.homeModules.default)

    # Aparência (ambas as sessões)
    ./modules/stylix.nix
    ./modules/dolphin-nord.nix

    # bspwm / X11
    ./modules/bspwm.nix
    ./modules/polybar.nix
    ./modules/picom.nix
    ./modules/dunst.nix        # desativado no niri via systemd

    # niri / Wayland
    ./modules/niri.nix
    ./modules/noctalia.nix
    # ./modules/screen-reflect.nix   # PAUSADO
    ./modules/mouse-invert.nix
    ./modules/hot-corner.nix

    # Cross-session
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

  # Pacotes cross-session (exclusivos de X11 → bspwm.nix; Wayland → niri.nix)
  home.packages = with pkgs; [
    pavucontrol
    mpv
    imv            # viewer Wayland-nativo (bspwm usa feh via bspwm.nix)
    brightnessctl
    file-roller
    p7zip
    unrar
  ];

  fonts.fontconfig.enable = true;
}
