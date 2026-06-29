# kitty e dunst: cores via Stylix. gtk: dolphin-nord.nix usa Nordic.

{ ... }:

{
  stylix.targets.dunst.enable   = true;
  stylix.targets.gtk.enable     = false;
  stylix.targets.waybar.enable  = false;
  stylix.targets.mako.enable    = false;
  stylix.targets.wezterm.enable = false;
}
