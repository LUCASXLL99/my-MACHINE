# home/lucasxll/modules/stylix.nix — targets Stylix ativos na versão atual
#
# Para ver todos disponíveis:
#   nix eval .#homeConfigurations.lucasxll.config.stylix.targets --json 2>/dev/null | jq keys
#
# kitty  ✅ ativo  | dunst ✅ ativo
# gtk    ❌ off    → dolphin-nord.nix usa Nordic/Kvantum
# waybar ❌ off    → CSS manual em niri.nix
# mako   ❌ off    → config inline em niri.nix
# wezterm ❌ off   → Lua manual em terminals.nix

{ ... }:

{
  stylix.targets.dunst.enable   = true;

  stylix.targets.gtk.enable     = false;
  stylix.targets.waybar.enable  = false;
  stylix.targets.mako.enable    = false;
  stylix.targets.wezterm.enable = false;
}
