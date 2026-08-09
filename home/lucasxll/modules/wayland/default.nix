{ ... }:
{
  imports = [
    ./mango.nix
    ./mango-tools.nix
    ./noctalia.nix
    ./wallpaper.nix
    # hot-corner.nix DESATIVADO em 2026-08-09: o mango-nightly crasha ao
    # disparar `toggleoverview` (overview_layout_card → wlr_scene_buffer
    # set_source_box → abort). O hot corner abria o overview automaticamente
    # e derrubava a sessão gráfica. Ver journal: 11 coredumps hoje.
    # ./hot-corner.nix
    ./clipboard.nix
    ./dolphin-extract.nix
  ];
}
