# home/lucasxll/modules/polybar.nix

{ pkgs, ... }:

let
  # Volume via wpctl — funciona com qualquer sink (fone BT, caixa, etc)
  volUp     = pkgs.writeShellScript "vol-up"     "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
  volDown   = pkgs.writeShellScript "vol-down"   "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
  volMute   = pkgs.writeShellScript "vol-mute"   "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
  volStatus = pkgs.writeShellScript "vol-status" ''
    INFO=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)
    VOL=$(echo "$INFO" | awk '{printf "%d", $2 * 100}')
    if echo "$INFO" | grep -q MUTED; then
      echo "%{F#f85149}󰝟 MUDO%{F-}"
    elif [ "$VOL" -ge 70 ]; then
      echo "%{F#8b949e}󰕾 $VOL%%%{F-}"
    elif [ "$VOL" -ge 30 ]; then
      echo "%{F#8b949e}󰖀 $VOL%%%{F-}"
    else
      echo "%{F#8b949e}󰕿 $VOL%%%{F-}"
    fi
  '';

  # Luz noturna
  nightUp = pkgs.writeShellScript "night-up" ''
    T=$(cat /tmp/nl 2>/dev/null || echo 6500)
    T=$(( T - 200 ))
    [ $T -lt 1500 ] && T=1500
    echo $T > /tmp/nl
    redshift -P -O $T &
  '';
  nightDown = pkgs.writeShellScript "night-down" ''
    T=$(cat /tmp/nl 2>/dev/null || echo 6500)
    T=$(( T + 200 ))
    [ $T -gt 6500 ] && T=6500
    echo $T > /tmp/nl
    if [ $T -ge 6500 ]; then redshift -x &
    else redshift -P -O $T &
    fi
  '';
  nightToggle = pkgs.writeShellScript "night-toggle" ''
    T=$(cat /tmp/nl 2>/dev/null || echo 6500)
    if [ $T -ge 6500 ]; then
      echo 3000 > /tmp/nl; redshift -P -O 3000 &
    else
      echo 6500 > /tmp/nl; redshift -x &
    fi
  '';
  nightIcon = pkgs.writeShellScript "night-icon" ''
    T=$(cat /tmp/nl 2>/dev/null || echo 6500)
    if   [ $T -ge 6500 ]; then echo "%{F#8b949e}󰖔%{F-}"
    elif [ $T -ge 4000 ]; then echo "%{F#d29922}󰖔%{F-}"
    else                        echo "%{F#f85149}󰖔%{F-}"
    fi
  '';
in
{
  home.packages = with pkgs; [ redshift ];

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
        modules-right  = "nightlight cpu memory battery volume";
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
        battery = "BAT1"; adapter = "ACAD";
        poll-interval = 5;
        label-full                   = "󰁹 FULL";
        label-full-foreground        = "\${colors.green}";
        label-charging               = "󰂄 %percentage%%";
        label-charging-foreground    = "\${colors.yellow}";
        label-discharging            = "󰁾 %percentage%%";
        label-discharging-foreground = "\${colors.fg-dim}";
        label-low                    = "󰁺 %percentage%%";
        label-low-foreground         = "\${colors.red}";
      };

      # Volume via wpctl — segue o sink padrão automaticamente (fone BT, caixa, etc)
      # scroll = ajusta volume, clique esq = mute, clique dir = pavucontrol
      "module/volume" = {
        type        = "custom/script";
        exec        = "${volStatus}";
        interval    = 1;
        click-left  = "${volMute}";
        click-right = "pavucontrol";
        scroll-up   = "${volUp}";
        scroll-down = "${volDown}";
      };

      "module/nightlight" = {
        type        = "custom/script";
        exec        = "${nightIcon}";
        interval    = 2;
        click-left  = "${nightToggle}";
        scroll-up   = "${nightUp}";
        scroll-down = "${nightDown}";
      };
    };
  };
}
