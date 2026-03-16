# home/lucasxll/modules/terminals.nix
# WezTerm + Kitty adaptados para canhoto
# Abas à direita, atalhos RAlt+tecla, scrollbar visível

{ config, ... }:

{
  # ── WezTerm ──────────────────────────────────────────────────
  xdg.configFile."wezterm/wezterm.lua".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.config/wezterm/wezterm.lua";

  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ./wezterm.lua;
  };

  # ── Kitty ────────────────────────────────────────────────────
  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./kitty.conf;
  };
}
