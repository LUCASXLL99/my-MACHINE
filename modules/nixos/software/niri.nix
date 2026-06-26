{ pkgs, ... }:

{
  programs.niri.enable = true;

  environment.systemPackages             = [ pkgs.xwayland-satellite ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
