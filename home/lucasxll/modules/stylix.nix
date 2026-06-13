# home/lucasxll/modules/stylix.nix
#
# Targets do Stylix — paleta base16 Tokyo Night injetada nos apps abaixo.
#
# ┌──────────────────────┬───────────┬─────────────────────────────────┐
# │ App                  │ Stylix    │ Motivo                          │
# ├──────────────────────┼───────────┼─────────────────────────────────┤
# │ kitty                │ ✅ ativo  │ cores removidas de terminals.nix│
# │ dunst                │ ✅ ativo  │ cores removidas de dunst.nix    │
# │ gtk                  │ ❌ off    │ dolphin-nord.nix usa Nordic     │
# │ waybar               │ ❌ off    │ CSS manual (Tokyo Night)        │
# │ mako                 │ ❌ off    │ config inline em niri.nix       │
# │ wezterm              │ ❌ off    │ config Lua manual em terminals  │
# └──────────────────────┴───────────┴─────────────────────────────────┘

{ ... }:

{
  stylix.targets.dunst.enable   = true;
  stylix.targets.gtk.enable     = false;
  stylix.targets.waybar.enable  = false;
  stylix.targets.mako.enable    = false;
  stylix.targets.wezterm.enable = false;
}
