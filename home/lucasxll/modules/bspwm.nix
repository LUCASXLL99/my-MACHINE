# home/lucasxll/modules/bspwm.nix

{ config, pkgs, ... }:

{
  # Pacotes exclusivos da sessão X11 (só são iniciados se fizer login no bspwm)
  home.packages = with pkgs; [
    networkmanagerapplet
    blueman
    copyq
    feh
    mpvpaper
    flameshot
    xwinwrap
    playerctl
  ];

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
      "Gimp"            = { state = "floating"; };
      "Rofi"            = { state = "floating"; border = false; };
      "Vivaldi-stable"  = { desktop = "^2"; follow = true; };
      "obsidian"        = { desktop = "^3"; follow = true; };
      "Dolphin"         = { state = "floating"; };
      "copyq"           = { state = "floating"; };
      "Blueman-manager" = { state = "floating"; };
    };
    startupPrograms = [
      "bspc monitor -d 1 2 3 4 5 6 7 8 9"

      # sleep 2: aguarda udev/X propagar dispositivos de input antes de aplicar xinput
      "sleep 2; for id in $(${pkgs.xorg.xinput}/bin/xinput list --id-only 2>/dev/null); do ${pkgs.xorg.xinput}/bin/xinput set-prop \"$id\" 'Coordinate Transformation Matrix' -1 0 1 0 -1 1 0 0 1 2>/dev/null || true; done"

      "pkill sxhkd; sxhkd -c ${config.xdg.configHome}/sxhkd/sxhkdrc"
      "pkill picom; picom --config ${config.xdg.configHome}/picom/picom.conf"
      "pkill dunst; dunst"
      "pkill copyq; sleep 0.5; copyq"
      "pkill mpris-proxy; mpris-proxy"
      "sleep 3; pkill nm-applet; nm-applet --indicator"
      "sleep 3; pkill blueman-applet; blueman-applet"

      "pkill mpvpaper; pkill feh; if [ -f ${config.home.homeDirectory}/Videos/wallpapers/wallpaper.mp4 ]; then mpvpaper -o 'no-audio loop' '*' ${config.home.homeDirectory}/Videos/wallpapers/wallpaper.mp4; elif ls ${config.home.homeDirectory}/Pictures/wallpapers/* 2>/dev/null; then feh --no-fehbg --bg-fill --randomize ${config.home.homeDirectory}/Pictures/wallpapers; else feh --no-fehbg --bg-color '#0e1117'; fi"

      "pkill polybar; sleep 0.5; for m in $(xrandr --query | awk '/ connected/{print $1}'); do MONITOR=$m polybar main --config=${config.xdg.configHome}/polybar/config.ini & done"
    ];
  };

  xdg.configFile."sxhkd/sxhkdrc".text = ''
    # Terminal
    super + Return
      wezterm
    super + shift + Return
      kitty

    # Launcher
    super + d
      rofi -show drun
    super + shift + d
      rofi -show run

    # Gerenciador de arquivos
    super + e
      dolphin

    # Fechar / matar
    super + w
      bspc node -c
    super + shift + q
      bspc node -c
    super + ctrl + q
      bspc node -k

    # Reiniciar bspwm / sxhkd
    super + shift + r
      bspc wm -r
    super + Escape
      pkill -USR1 -x sxhkd

    # Foco (hjkl)
    super + {h,j,k,l}
      bspc node -f {west,south,north,east}

    # Mover
    super + shift + {h,j,k,l}
      bspc node -s {west,south,north,east}

    # Redimensionar
    super + alt + {h,j,k,l}
      bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}

    # Layout
    super + m
      bspc desktop -l next
    super + f
      bspc node -t ~fullscreen
    super + shift + f
      bspc node -t ~floating
    super + t
      bspc node -t ~tiled

    # Desktops
    super + {1-9}
      bspc desktop -f '{1-9}'
    super + shift + {1-9}
      bspc node -d '{1-9}'

    # Volume
    XF86AudioRaiseVolume
      wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
    XF86AudioLowerVolume
      wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    XF86AudioMute
      wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

    # Mídia
    XF86AudioPlay
      playerctl play-pause
    XF86AudioPause
      playerctl play-pause
    XF86AudioNext
      playerctl next
    XF86AudioPrev
      playerctl previous

    # Brilho
    XF86MonBrightnessUp
      brightnessctl set +10%
    XF86MonBrightnessDown
      brightnessctl set 10%-

    # Screenshot
    Print
      flameshot gui
    super + Print
      flameshot full

    # Clipboard
    super + v
      copyq show
  '';
}
