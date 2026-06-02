# modules/nixos/software/niri.nix
# Niri via niri-flake + xwayland-satellite.
# Binários via cache niri.cachix.org — sem compilação local.
# services.displayManager.sddm.wayland.enable é diferente (requer kwin).

{ pkgs, ... }:

{
  programs.niri.enable = true;

  environment.systemPackages = [ pkgs.xwayland-satellite ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
}
