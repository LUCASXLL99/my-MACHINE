# home/lucasxll/modules/polybar.nix

{ pkgs, ... }:

{
  services.polybar = {
    enable  = true;
    package = pkgs.polybar.override { pulseSupport = true; };
    script  = "";

    config = {
      "colors" = {
        bg     = "#0e1117"; bg-alt = "#161b22";
        fg     = "#e6edf3"; fg-dim = "#8b949e";
        accent = "#58a6ff"; green  = "#3fb950";
        yellow = "#d29922"; red    = "#f85149";
        border = "#30363d";
      };

      "bar/main" = {
        width      = "100%"; height = 32;
        background = "\${colors.bg}"; foreground = "\${colors.fg}";
        border-bottom-size  = 2;
        border-bottom-color = "\${colors.border}";
        font-0 = "JetBrainsMono Nerd Font:size=11:weight=bold;3";
        font-1 = "JetBrainsMono Nerd Font:size=13;3";
        font-2 = "Noto Sans:size=10;2";
        modules-left   = "bspwm";
        modules-center = "clock";
        modules-right  = "cpu memory battery volume";
        padding-left = 1; padding-right = 2; module-margin = 1;
        tray-position = "right"; tray-padding = 4;
        tray-background = "\${colors.bg}";
        cursor-click = "pointer";
      };

      "module/bspwm" = {
        type = "internal/bspwm";
        label-focused             = " %name% ";
        label-focused-foreground  = "\${colors.bg}";
        label-focused-background  = "\${colors.accent}";
        label-occupied            = " %name% ";
        label-occupied-foreground = "\${colors.fg-dim}";
        label-empty               = " %name% ";
        label-empty-foreground    = "\${colors.border}";
        label-urgent              = " %name% ";
        label-urgent-foreground   = "\${colors.red}";
      };

      "module/clock" = {
        type = "internal/date"; interval = 30;
        date = "%d/%m"; time = "%H:%M";
        label = "%date%  %time%";
        label-foreground = "\${colors.fg}";
      };

      "module/cpu" = {
        type = "internal/cpu"; interval = 2;
        label = "CPU %percentage:2%%";
        label-foreground = "\${colors.fg-dim}";
      };

      "module/memory" = {
        type = "internal/memory"; interval = 3;
        label = "MEM %percentage_used:2%%";
        label-foreground = "\${colors.fg-dim}";
      };

      "module/battery" = {
        type    = "internal/battery";
        full-at = 99; low-at = 20;
        battery = "BAT0"; adapter = "AC";
        label-full              = "BAT FULL";
        label-full-foreground   = "\${colors.green}";
        label-charging          = "BAT %percentage%%+";
        label-charging-foreground = "\${colors.yellow}";
        label-discharging       = "BAT %percentage%%";
        label-discharging-foreground = "\${colors.fg-dim}";
        label-low               = "BAT LOW %percentage%%";
        label-low-foreground    = "\${colors.red}";
      };

      "module/volume" = {
        type = "internal/pulseaudio";
        label-volume            = "VOL %percentage%%";
        label-volume-foreground = "\${colors.fg-dim}";
        label-muted             = "MUDO";
        label-muted-foreground  = "\${colors.red}";
        click-right             = "pavucontrol";
      };
    };
  };
}
