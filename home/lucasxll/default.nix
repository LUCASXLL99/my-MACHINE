# home/lucasxll/default.nix
# Entrada do Home Manager para o usuário lucasxll.
#
# SESSÕES DISPONÍVEIS
# ───────────────────
#   Niri   (Wayland) — sessão PRINCIPAL — usada diariamente
#   bspwm  (X11)     — sessão RESERVA   — fallback / manutenção
#
# Cada sessão importa apenas os módulos que lhe pertencem.
# Pacotes exclusivos de cada sessão ficam no próprio módulo da sessão,
# nunca aqui — este arquivo só carrega o que é realmente cross-session.

{ config, pkgs, inputs, ... }:

{
  imports = [
    (inputs.noctalia.homeModules.default)  # define programs.noctalia-shell

    # ── Aparência / tema (ambas as sessões) ──────────────────────
    ./modules/stylix.nix
    ./modules/dolphin-nord.nix

    # ── Sessão X11 ── bspwm (RESERVA) ────────────────────────────
    # Pacotes X11-exclusivos (feh, flameshot, xwinwrap, mpvpaper…)
    # estão dentro de bspwm.nix, não aqui.
    ./modules/bspwm.nix
    ./modules/polybar.nix
    ./modules/picom.nix
    ./modules/dunst.nix        # desativado automaticamente no niri via systemd

    # ── Sessão Wayland ── niri (PRINCIPAL) ───────────────────────
    # Pacotes Wayland-exclusivos (grim, slurp, wl-clipboard…)
    # estão dentro de niri.nix, não aqui.
    ./modules/niri.nix
    ./modules/noctalia.nix
    # ./modules/screen-reflect.nix   # PAUSADO — descomentar para reativar o espelho
    ./modules/mouse-invert.nix
    ./modules/hot-corner.nix   # hot corner canto superior direito → overview

    # ── Ferramentas cross-session ─────────────────────────────────
    # Só entra aqui o que funciona igualmente nas duas sessões.
    ./modules/terminals.nix    # wezterm + kitty (X11 e Wayland)
    ./modules/clipboard.nix    # copyq (X11 direto; Wayland via xwayland)
    ./modules/yazi.nix         # file manager TUI
    ./modules/lf.nix           # file manager TUI alternativo
    ./modules/neovim.nix
    ./modules/zsh.nix          # inclui zoxide
    ./modules/files.nix        # MIME — preferências da sessão Wayland

    # ── Wallpaper ─────────────────────────────────────────────────
    ./modules/wallpaper.nix      # mpvpaper via systemd (restart automático)

    # ── Coding agents ─────────────────────────────────────────────
    ./modules/coding-agents.nix  # opencode (sempre atualizado) + pi

    # ── Cargo config ──────────────────────────────────────────────
    ./modules/cargo-config.nix   # gera ~/.cargo/config.toml com paths do nix store
  ];

  home.username      = "lucasxll";
  home.homeDirectory = "/home/lucasxll";
  home.stateVersion  = "25.05";

  programs.home-manager.enable = true;

  # ── Pacotes cross-session ──────────────────────────────────────
  # Só ficam aqui pacotes que têm uso real em AMBAS as sessões.
  # Pacotes exclusivos de X11  → bspwm.nix
  # Pacotes exclusivos Wayland → niri.nix
  home.packages = with pkgs; [
    # Áudio / vídeo
    pavucontrol     # mixer gráfico (X11 e Wayland via xwayland)
    mpv             # player (X11 e Wayland nativo)

    # Imagens — viewer Wayland-nativo (sessão principal)
    # Em X11/bspwm o feh é usado diretamente (instalado em bspwm.nix)
    imv

    # Hardware
    brightnessctl   # controle de brilho (funciona nos dois)

    # Arquivos / compactação
    file-roller
    p7zip
    unrar
  ];

  fonts.fontconfig.enable = true;
}
