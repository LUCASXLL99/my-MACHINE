# Tudo unificado em Tokyo Night via Stylix (mesma base16 do mango/neovim).
# GTK, Qt (kvantum via qtct) e rofi são gerados do esquema Tokyo Night.
# bspwm: target desativado — o bspwm.nix tem paleta própria (sessão X11
# legada/fallback), não queremos que o Stylix sobrescreva.
# starship: gerenciado manualmente no shell/zsh.nix (tema Tokyo Night já
# hardcoded lá) — o target do Stylix espera cores bright que o esquema
# custom não define.
# waybar, mako, wezterm: gerenciados por outros módulos ou não usados.

{ ... }:

{
  stylix.targets.dunst.enable   = true;
  stylix.targets.gtk.enable     = true;
  stylix.targets.qt.enable      = true;
  stylix.targets.rofi.enable    = true;
  stylix.targets.bspwm.enable   = false;
  stylix.targets.starship.enable = false;
  stylix.targets.waybar.enable  = false;
  stylix.targets.mako.enable    = false;
  stylix.targets.wezterm.enable = false;
}
