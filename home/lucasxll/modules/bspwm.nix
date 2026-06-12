# home/lucasxll/modules/bspwm.nix

{ config, pkgs, lib, ... }:

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
    # startupPrograms: apenas o que não pode ser um serviço systemd.
    # Daemons estáveis (sxhkd, picom, dunst, etc.) vivem em
    # systemd.user.services abaixo — reiniciam automaticamente se caírem.
    startupPrograms = [
      "bspc monitor -d 1 2 3 4 5 6 7 8 9"

      # Inicia os daemons via systemd (restart automático se caírem)
      "systemctl --user start bspwm-sxhkd bspwm-picom bspwm-dunst bspwm-copyq bspwm-mpris-proxy bspwm-nm-applet bspwm-blueman"

      # Aplica matriz de espelho em todos os dispositivos de input (X11)
      "sleep 2; for id in $(${pkgs.xorg.xinput}/bin/xinput list --id-only 2>/dev/null); do ${pkgs.xorg.xinput}/bin/xinput set-prop \"$id\" 'Coordinate Transformation Matrix' -1 0 1 0 -1 1 0 0 1 2>/dev/null || true; done"

      # Wallpaper (lógica com múltiplas fontes — fica aqui por ora)
      "pkill mpvpaper; pkill feh; if [ -f ${config.home.homeDirectory}/Videos/wallpapers/wallpaper.mp4 ]; then mpvpaper -o 'no-audio loop' '*' ${config.home.homeDirectory}/Videos/wallpapers/wallpaper.mp4; elif ls ${config.home.homeDirectory}/Pictures/wallpapers/* 2>/dev/null; then feh --no-fehbg --bg-fill --randomize ${config.home.homeDirectory}/Pictures/wallpapers; else feh --no-fehbg --bg-color '#0e1117'; fi"

      # Polybar (por monitor — shell expansion necessária)
      "pkill polybar; sleep 0.5; for m in $(xrandr --query | awk '/ connected/{print $1}'); do MONITOR=$m polybar main --config=${config.xdg.configHome}/polybar/config.ini & done"
    ];
  };

  # ── Serviços systemd para daemons do bspwm ──────────────────────────────────
  # Condicionados a DESKTOP_SESSION=bspwm: não interferem na sessão niri.
  # Os serviços bspwm-* NÃO têm WantedBy: não iniciam automaticamente.
  # São iniciados explicitamente pelo startupPrograms do bspwm abaixo,
  # e reiniciados automaticamente pelo systemd se caírem (Restart=on-failure).
  systemd.user.services = let
    bspwmOnly = {
      Unit.After       = [ "graphical-session.target" ];
      Unit.PartOf      = [ "graphical-session.target" ];
      # Sem WantedBy: evita iniciar em niri ou outras sessões.
      # O bspwm chama 'systemctl --user start bspwm-*' via startupPrograms.
    };
  in {
    bspwm-sxhkd = lib.recursiveUpdate bspwmOnly {
      Unit.Description = "sxhkd hotkey daemon (bspwm)";
      Service = {
        ExecStart = "${pkgs.sxhkd}/bin/sxhkd -c ${config.xdg.configHome}/sxhkd/sxhkdrc";
        Restart   = "on-failure"; RestartSec = "1s";
      };
    };
    bspwm-picom = lib.recursiveUpdate bspwmOnly {
      Unit.Description = "picom compositor (bspwm)";
      Service = {
        ExecStart = "${pkgs.picom}/bin/picom --config ${config.xdg.configHome}/picom/picom.conf";
        Restart   = "on-failure"; RestartSec = "2s";
      };
    };
    bspwm-dunst = lib.recursiveUpdate bspwmOnly {
      Unit.Description = "dunst notification daemon (bspwm)";
      Service.ExecStart = "${pkgs.dunst}/bin/dunst";
      Service.Restart   = "on-failure";
    };
    bspwm-copyq = lib.recursiveUpdate bspwmOnly {
      Unit.Description = "CopyQ clipboard manager (bspwm)";
      Service.ExecStart = "${pkgs.copyq}/bin/copyq";
      Service.Restart   = "on-failure"; Service.RestartSec = "1s";
    };
    bspwm-mpris-proxy = lib.recursiveUpdate bspwmOnly {
      Unit.Description = "mpris-proxy — media key bridge (bspwm)";
      Service.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
      Service.Restart   = "on-failure";
    };
    bspwm-nm-applet = lib.recursiveUpdate bspwmOnly {
      Unit.Description = "nm-applet system tray (bspwm)";
      Service.ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator";
      Service.Restart   = "on-failure"; Service.RestartSec = "3s";
    };
    bspwm-blueman = lib.recursiveUpdate bspwmOnly {
      Unit.Description = "blueman-applet system tray (bspwm)";
      Service.ExecStart = "${pkgs.blueman}/bin/blueman-applet";
      Service.Restart   = "on-failure"; Service.RestartSec = "3s";
    };
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
