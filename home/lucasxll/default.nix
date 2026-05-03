# home/lucasxll/default.nix
# Entrada do Home Manager para o usuário lucasxll

{ config, pkgs, inputs, ... }:

{
  imports = [
    (inputs.noctalia.homeModules.default)  # define programs.noctalia-shell
    # ── Aparência / tema ─────────────────────────────────────────
    ./modules/stylix.nix
    ./modules/dolphin-nord.nix
    # ── Sessão X11 (bspwm — fallback) ────────────────────────────
    ./modules/bspwm.nix
    ./modules/polybar.nix
    ./modules/picom.nix
    ./modules/dunst.nix
    # ── Sessão Wayland (niri — principal) ────────────────────────
    ./modules/niri.nix
    ./modules/noctalia.nix
    ./modules/screen-reflect.nix
    ./modules/mouse-invert.nix
    # ── Ferramentas ───────────────────────────────────────────────
    ./modules/terminals.nix
    ./modules/clipboard.nix
    ./modules/yazi.nix
    ./modules/lf.nix
    ./modules/neovim.nix
    ./modules/zsh.nix
    ./modules/files.nix
  ];

  home.username      = "lucasxll";
  home.homeDirectory = "/home/lucasxll";
  home.stateVersion  = "25.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    pavucontrol
    feh
    flameshot
    brightnessctl
    file-roller
    p7zip
    unrar

    # Live wallpaper
    xwinwrap
    mpv
  ];

  fonts.fontconfig.enable = true;
}
