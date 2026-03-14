# home/lucasxll/modules/dunst.nix

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
        frame_width = 2; frame_color = "#30363d";
        corner_radius = 8;
        font = "JetBrainsMono Nerd Font 10";
        line_height = 2; markup = "full";
        format = "<b>%s</b>\\n%b";
        alignment = "left"; word_wrap = true;
        sort = true; transparency = 8;
        separator_height = 2; separator_color = "#30363d";
        mouse_left_click  = "close_current";
        mouse_right_click = "do_action, close_current";
      };
      urgency_low      = { background = "#161b22"; foreground = "#8b949e"; frame_color = "#30363d"; timeout = 4; };
      urgency_normal   = { background = "#0e1117"; foreground = "#e6edf3"; frame_color = "#58a6ff"; timeout = 6; };
      urgency_critical = { background = "#1a0a0a"; foreground = "#f85149"; frame_color = "#f85149"; timeout = 0; };
    };
  };
}
