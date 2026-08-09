# Layout e comportamento. Cores gerenciadas pelo Stylix.
# A fonte é forçada aqui (mkForce) porque o target do Stylix setaria a
# sansSerif (Inter); mantemos a monospace do usuário no dunst.

{ config, lib, ... }:

{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        monitor = 0; follow = "mouse";
        origin = "top-right"; offset = "12x44";
        width = 320; height = 200;
        padding = 12; horizontal_padding = 14;
        frame_width = 2; corner_radius = 8;
        font = lib.mkForce "JetBrainsMono Nerd Font 10";
        line_height = 2; markup = "full";
        format = "<b>%s</b>\\n%b";
        alignment = "left"; word_wrap = true;
        sort = true; transparency = 8;
        separator_height = 2;
        mouse_left_click  = "close_current";
        mouse_right_click = "do_action, close_current";
      };
      urgency_low      = { timeout = 4; };
      urgency_normal   = { timeout = 6; };
      urgency_critical = { timeout = 0; };
    };
  };
}
