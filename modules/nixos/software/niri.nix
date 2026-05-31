# modules/nixos/software/niri.nix
#
# Instala o Niri e xwayland-satellite.
# O SDDM detecta a sessão via /share/wayland-sessions/niri.desktop.
#
# NOTA: services.displayManager.sddm.wayland.enable é diferente — faz o
# SDDM ele mesmo rodar sob Wayland (precisa de kwin). Não usar aqui.

{ pkgs, ... }:

{
  programs.niri.enable = true;

  environment.systemPackages = [ pkgs.xwayland-satellite ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
}
