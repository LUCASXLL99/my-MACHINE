# home/lucasxll/modules/bspwm.nix

{ config, pkgs, ... }:

{
  xsession.windowManager.bspwm = {
    enable = true;
    monitors."*" = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" ];
    settings = {
      border_width          = 2;
      window_gap            = 8;
      split_ratio           = 0.52;
      normal_border_color   = "#30363d";
      active_border_color   = "#30363d";
      focused_border_color  = "#58a6ff";
      presel_feedback_color = "#3fb950";
      borderless_monocle    = true;
      gapless_monocle       = true;
      click_to_focus        = "button1";
      focus_follows_pointer = true;
      top_padding           = 40;
    };
    rules = {
      "Gimp"           = { state = "floating"; };
      "Rofi"           = { state = "floating"; border = false; };
      "Vivaldi-stable" = { desktop = "^2"; follow = true; };
      "obsidian"       = { desktop = "^3"; follow = true; };
    };
    startupPrograms = [
      "pkill sxhkd; sxhkd"
      "pkill picom; picom --config ${config.xdg.configHome}/picom/picom.conf"
      "pkill dunst; dunst"
      "keepassxc"
      "pkill greenclip; greenclip daemon"
      "feh --no-fehbg --bg-fill --randomize ${config.home.homeDirectory}/Pictures/wallpapers || feh --no-fehbg --bg-color '#0e1117'"
      "pkill polybar; sleep 0.5; for m in $(xrandr --query | awk '/ connected/{print $1}'); do MONITOR=$m polybar main --config=${config.xdg.configHome}/polybar/config.ini & done"
    ];
  };
}
