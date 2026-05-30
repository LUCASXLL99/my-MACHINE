# modules/nixos/display/niri.nix
#
# Adiciona o Niri ao sistema sem remover nada existente.
# O SDDM detecta a sessão Niri automaticamente via /share/wayland-sessions/niri.desktop
# que o programs.niri.enable instala no lugar certo.
#
# NOTA: NÃO usar services.displayManager.sddm.wayland.enable = true aqui.
#       Essa opção faz o SDDM *ele mesmo* rodar sob Wayland (precisa de kwin),
#       o que é diferente de "listar sessões Wayland no SDDM".
#       O SDDM em modo X11 já lista /share/wayland-sessions/ automaticamente.

{ pkgs, ... }:

{
  # programs.niri é o módulo oficial NixOS do Niri:
  #   - instala o pacote
  #   - instala /share/wayland-sessions/niri.desktop  ← SDDM lê isso
  #   - habilita o socket de IPC e polkit necessários
  programs.niri.enable = true;

  # xwayland-satellite: compatibilidade X11 dentro do Niri
  # (Steam, JetBrains, Electron, etc.) sem usar Xwayland puro
  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];

  # Força apps Electron/Chromium a usarem Wayland nativo na sessão Niri.
  # Funciona por variável de ambiente — não afeta X11.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Portal XDG wlroots — screen sharing e file picker no Niri
  # Coexiste com xdg-desktop-portal-kde e xdg-desktop-portal-gtk
  # já declarados em hosts/nixos/default.nix
  xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-wlr ];
}
