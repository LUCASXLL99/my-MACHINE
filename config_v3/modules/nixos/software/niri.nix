# modules/nixos/software/niri.nix
# Adiciona Niri ao sistema. O SDDM detecta a sessão via /share/wayland-sessions/niri.desktop.
#
# NOTA: sddm.wayland.enable = true faz o SDDM *ele mesmo* rodar sob Wayland (precisa kwin).
#       O SDDM em modo X11 já lista sessões Wayland automaticamente — não usar aqui.

{ pkgs, ... }:

{
  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    xwayland-satellite  # compat X11 (Steam, JetBrains, Electron, etc.)
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-wlr ];
}
