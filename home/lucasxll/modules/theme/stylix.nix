# home/lucasxll/modules/stylix.nix
#
# Targets do Stylix — apenas os que existem na versão atual.
#
# Stylix injeta a paleta base16 Tokyo Night nos apps listados aqui.
# Targets que não existem nessa versão foram removidos para evitar erros.
# À medida que o Stylix for atualizado (nix flake update), novos targets
# podem ser habilitados aqui.
#
# Para ver todos os targets disponíveis na versão atual:
#   nix eval .#homeConfigurations.lucasxll.config.stylix.targets --json 2>/dev/null | jq keys
#
# ┌──────────────────────┬───────────┬─────────────────────────────────────────┐
# │ App                  │ Stylix    │ Motivo                                  │
# ├──────────────────────┼───────────┼─────────────────────────────────────────┤
# │ kitty                │ ✅ ativo  │ cores removidas de terminals.nix        │
# │ dunst                │ ✅ ativo  │ cores removidas de dunst.nix            │
# │ gtk                  │ ❌ off    │ dolphin-nord.nix usa Nordic/Kvantum     │
# │ waybar               │ ❌ off    │ CSS manual em niri.nix (Tokyo Night)    │
# │ mako                 │ ❌ off    │ config inline em niri.nix               │
# │ wezterm              │ ❌ off    │ config Lua manual em terminals.nix      │
# │ starship             │ removido  │ target não existe nessa versão Stylix   │
# │ zsh-syntax-highlight │ removido  │ target não existe nessa versão Stylix   │
# └──────────────────────┴───────────┴─────────────────────────────────────────┘

{ ... }:

{
  # ── Targets ativos ────────────────────────────────────────────
  stylix.targets.dunst.enable = true;

  # ── Targets desativados (gerenciados manualmente) ─────────────
  stylix.targets.gtk.enable     = false;
  stylix.targets.waybar.enable  = false;
  stylix.targets.mako.enable    = false;
  stylix.targets.wezterm.enable = false;
}
