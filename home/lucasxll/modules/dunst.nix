# home/lucasxll/modules/dunst.nix
#
# Notificações X11 — estrutura e comportamento.
# As CORES são gerenciadas pelo Stylix (stylix.targets.dunst.enable = true em stylix.nix).
# Ao ativar o Stylix, ele injeta as cores base16 diretamente em services.dunst.settings.
# O que permanece aqui: layout, fonte, timeouts, ações de mouse.

{ ... }:

{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        monitor = 0; follow = "mouse";
        origin = "top-right"; offset = "12x44";
        width = 320; height = 200;
        padding = 12; horizontal_padding = 14;
        frame_width = 2;
        corner_radius = 8;
        font = "JetBrainsMono Nerd Font 10";
        line_height = 2; markup = "full";
        format = "<b>%s</b>\\n%b";
        alignment = "left"; word_wrap = true;
        sort = true; transparency = 8;
        separator_height = 2;
        mouse_left_click  = "close_current";
        mouse_right_click = "do_action, close_current";
      };
      # Timeouts — sem cores (Stylix cuida delas)
      urgency_low      = { timeout = 4; };
      urgency_normal   = { timeout = 6; };
      urgency_critical = { timeout = 0; };
    };
  };
}
