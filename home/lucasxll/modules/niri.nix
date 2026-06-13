# home/lucasxll/modules/niri.nix
# Config do compositor Niri + serviços systemd de suporte.
#
# O noctalia-shell (noctalia.nix) gerencia: waybar, mako, fuzzel, swww,
# hyprlock, swayidle. Este arquivo mantém apenas a config KDL do compositor,
# o serviço xwayland-satellite e overrides de conflitos (picom, dunst, portal-gnome).

{ config, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    grim          # screenshot nativo Wayland
    slurp         # seleção de área (Ctrl+Print)
    wl-clipboard  # wl-copy / wl-paste
    wlr-randr     # controle de output (niri-mirror / niri-reset)
    xorg.xauth    # cookie MIT-MAGIC-COOKIE para xwayland-satellite
    # Fallbacks — descomentar SOMENTE se noctalia não subir:
    # waybar mako fuzzel swww hyprlock swayidle
  ];

  xdg.configFile."niri/config.kdl".text = ''
    // ── INPUT ──────────────────────────────────────────────────────
    input {
        keyboard {
            xkb {
                layout "br"
                variant "nodeadkeys"
            }
            repeat-delay 400
            repeat-rate 30
        }
        mouse {
            natural-scroll
        }
        touchpad {
            natural-scroll
            tap
        }
        focus-follows-mouse max-scroll-amount="0%"
        warp-mouse-to-focus
    }

    // ── OUTPUT ─────────────────────────────────────────────────────
    output "eDP-1" {
        scale 1.0
        // transform "normal"  // padrão; use niri-mirror (Mod+F5) para espelhar
    }

    // ── LAYOUT ─────────────────────────────────────────────────────
    layout {
        gaps 8
        struts {
            left 32
            right 32
            top 0
            bottom 32
        }
        center-focused-column "never"

        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
            proportion 1.0
        }
        default-column-width { proportion 0.5; }

        focus-ring {
            width 2
            active-color   "#7aa2f7"
            inactive-color "#30363d"
        }
        border { off; }
        shadow {
            on
            softness 30
            spread 5
            offset x=0 y=5
            color "#0007"
        }
    }

    prefer-no-csd
    animations {
      slowdown 0.8;
      // window-open off: janela não aparece à direita antes do niri-autoplace mover.
      window-open { off; }
      // horizontal-view-movement off: move-column-to-first fica instantâneo
      // sem slide visível. Navegação normal (Mod+H/S) também.
      horizontal-view-movement { off; }
    }

    hotkey-overlay {
        skip-at-startup
    }

    // ── AMBIENTE ───────────────────────────────────────────────────
    environment {
        // /run/wrappers/bin primeiro: sudo e setuid ficam aqui (nosuid no nix store).
        PATH "/run/wrappers/bin:/run/current-system/sw/bin:/etc/profiles/per-user/lucasxll/bin:/nix/var/nix/profiles/default/bin:/usr/local/bin:/usr/bin:/bin"

        QT_QPA_PLATFORM "wayland"
        ELECTRON_OZONE_PLATFORM_HINT "auto"
        _JAVA_AWT_WM_NONREPARENTING "1"

        // DISPLAY fixo: xwayland-satellite sobe em :1 (:0 é ocupado pelo SDDM)
        DISPLAY ":1"
    }

    screenshot-path "~/Pictures/Screenshots/Screenshot_%Y-%m-%d_%H-%M-%S.png"

    // ── STARTUP ────────────────────────────────────────────────────
    // sleep 1: garante que o socket do niri está pronto antes de exportar.
    // DISPLAY incluído: necessário para apps X11 lançados fora do xwayland-satellite.
    spawn-at-startup "sh" "-c" "sleep 1 && dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP NIRI_SOCKET DISPLAY"
    spawn-at-startup "sh" "-c" "pkill mpris-proxy; mpris-proxy"
    spawn-at-startup "sh" "-c" "sleep 2 && systemctl --user restart mouse-invert-y"
    spawn-at-startup "sh" "-c" "sleep 2 && noctalia-shell"
    spawn-at-startup "sh" "-c" "sleep 5 && nm-applet --indicator"
    spawn-at-startup "sh" "-c" "sleep 5 && systemctl --user start niri-blueman-applet"
    // cliphist → systemd (clipboard.nix); wallpaper → systemd (wallpaper.nix)

    // ── ATALHOS ────────────────────────────────────────────────────
    binds {
        // Terminais
        Mod+Return       { spawn "wezterm"; }
        Mod+T            { spawn "wezterm"; }
        Mod+Shift+Return { spawn "kitty"; }

        // Launchers
        Mod+D { spawn "noctalia-shell" "ipc" "call" "launcher" "toggle"; }
        Mod+R { spawn "sh" "-c" "DISPLAY=:1 rofi -show drun"; }

        // Apps
        Mod+E { spawn "dolphin"; }
        Mod+B { spawn "blueman-manager"; }
        // Mod+A: aguarda socket X1 antes de lançar (race condition com xwayland-satellite)
        Mod+A { spawn "sh" "-c" "for i in $(seq 1 20); do [ -S /tmp/.X11-unix/X1 ] && break; sleep 0.5; done; android-studio"; }

        // Clipboard
        Mod+V { spawn "sh" "-c" "cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"; }

        // Screenshot
        Print       { screenshot; }
        Shift+Print { screenshot-screen; }
        Ctrl+Print  { spawn "sh" "-c" "sel=$(slurp 2>/dev/null) || exit 0; grim -g \"$sel\" - | wl-copy"; }

        // Lock
        Mod+Ctrl+L { spawn "noctalia-shell" "ipc" "call" "lockScreen" "lock"; }

        // Sessão
        Mod+Shift+E { quit; }
        Mod+Shift+S { spawn "sh" "-c" "systemctl suspend"; }

        // Janelas
        Mod+Q       { close-window; }
        Mod+F       { maximize-column; }
        Mod+Shift+F { fullscreen-window; }
        Mod+Space   { toggle-window-floating; }
        Mod+C       { center-column; }

        // Foco — colunas
        Mod+H { focus-column-left; }
        Mod+L { focus-column-right; }
        Mod+J { focus-window-down; }
        Mod+K { focus-window-up; }
        Mod+Left  { focus-column-left; }
        Mod+Right { focus-column-right; }
        Mod+Down  { focus-window-down; }
        Mod+Up    { focus-window-up; }

        // Mover colunas
        Mod+Shift+H { move-column-left; }
        Mod+Shift+L { move-column-right; }
        Mod+Shift+J { move-window-down; }
        Mod+Shift+K { move-window-up; }

        // Workspaces
        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }
        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        Mod+Shift+6 { move-column-to-workspace 6; }
        Mod+Shift+7 { move-column-to-workspace 7; }
        Mod+Shift+8 { move-column-to-workspace 8; }
        Mod+Shift+9 { move-column-to-workspace 9; }

        Mod+Tab       { focus-workspace-down; }
        Mod+Shift+Tab { focus-workspace-up; }

        // Largura de colunas
        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }
        Mod+Ctrl+H { set-column-width "33%"; }
        Mod+Ctrl+S { set-column-width "50%"; }
        Mod+Ctrl+L { set-column-width "66%"; }

        // Altura de janelas
        Mod+Shift+Minus { set-window-height "-10%"; }
        Mod+Shift+Equal { set-window-height "+10%"; }

        // Larguras preset
        Mod+W { switch-preset-column-width; }

        // Overview
        Mod+O     { toggle-overview; }
        Mod+Comma { consume-window-into-column; }
        Mod+Period { expel-window-from-column; }

        // Espelho (niri-mirror / niri-reset definidos em mouse-invert.nix)
        Mod+F5 { spawn "niri-mirror"; }
        Mod+F6 { spawn "niri-reset"; }

        // Wallpaper toggle
        Mod+Semicolon { spawn "sh" "-c" "pkill mpvpaper || mpvpaper -o 'no-audio loop' '*' ~/Pictures/wallpapers/wallpaper.mp4"; }

        // Mídia
        XF86AudioRaiseVolume  { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
        XF86AudioLowerVolume  { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
        XF86AudioMute         { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
        XF86AudioPlay         { spawn "playerctl" "play-pause"; }
        XF86AudioPause        { spawn "playerctl" "play-pause"; }
        XF86AudioNext         { spawn "playerctl" "next"; }
        XF86AudioPrev         { spawn "playerctl" "previous"; }
        XF86MonBrightnessUp   { spawn "brightnessctl" "set" "5%+"; }
        XF86MonBrightnessDown { spawn "brightnessctl" "set" "5%-"; }
    }

    // ── REGRAS DE JANELA ───────────────────────────────────────────
    window-rule {
        match app-id="blueman-manager"
        match app-id="pavucontrol"
        match app-id="org.kde.dolphin"
        open-floating true
    }

    window-rule {
        match app-id="noctalia"
        match app-id="noctalia-shell"
        open-floating true
        draw-border-with-background false
    }
  '';

  # ════════════════════════════════════════════════════════════════
  # NIRI-AUTOPLACE — move toda janela nova para a primeira coluna
  # ════════════════════════════════════════════════════════════════
  # Cada janela é rastreada pelo ID numérico em $SEEN para garantir
  # que seja movida só uma vez mesmo se receber foco novamente.
  systemd.user.services.niri-autoplace = {
    Unit = {
      Description = "Niri auto-place — move janelas novas para a primeira posição";
      After       = [ "niri.service" ];
      BindsTo     = [ "niri.service" ];
    };
    Service = {
      Type    = "simple";
      Restart = "on-failure";
      RestartSec = "2s";
      ExecStart = pkgs.writeShellScript "niri-autoplace" ''
        for i in $(seq 1 20); do
          [ -n "$NIRI_SOCKET" ] && break
          NIRI_SOCKET=$(${pkgs.systemd}/bin/systemctl --user show-environment 2>/dev/null \
            | grep '^NIRI_SOCKET=' | cut -d= -f2)
          sleep 0.5
        done
        [ -z "$NIRI_SOCKET" ] && { echo "niri-autoplace: NIRI_SOCKET não encontrado" >&2; exit 1; }
        export NIRI_SOCKET

        SEEN=$(mktemp -d /tmp/niri-autoplace-XXXXXX)
        trap 'rm -rf "$SEEN"' EXIT INT TERM

        ${pkgs.niri}/bin/niri msg --json event-stream \
          | ${pkgs.jq}/bin/jq -c --unbuffered '
              select(.WindowOpenedOrChanged != null)
              | .WindowOpenedOrChanged.window
              | select(.is_floating == false or .is_floating == null)
              | {id, app_id}
            ' \
          | while IFS= read -r ev; do
              wid=$(printf '%s' "$ev" | ${pkgs.jq}/bin/jq -r '.id // ""')
              app_id=$(printf '%s' "$ev" | ${pkgs.jq}/bin/jq -r '.app_id // ""')
              [ -z "$wid" ] && continue
              if [ ! -f "$SEEN/$wid" ]; then
                touch "$SEEN/$wid"
                ${pkgs.niri}/bin/niri msg action move-column-to-first
                echo "niri-autoplace: moveu '$app_id' (id=$wid)"
              fi
            done
      '';
    };
    Install.WantedBy = [ "niri.service" ];
  };

  # ════════════════════════════════════════════════════════════════
  # BLUETOOTH APPLET — iniciado via spawn-at-startup, não WantedBy
  # ════════════════════════════════════════════════════════════════
  systemd.user.services.niri-blueman-applet = {
    Unit = {
      Description = "Blueman applet — Bluetooth tray (niri)";
      After       = [ "graphical-session.target" ];
      PartOf      = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart  = "${pkgs.blueman}/bin/blueman-applet";
      Restart    = "on-failure";
      RestartSec = "3s";
    };
  };

  # ════════════════════════════════════════════════════════════════
  # XWAYLAND-SATELLITE — compatibilidade X11 no Niri
  # ════════════════════════════════════════════════════════════════
  systemd.user.services.xwayland-satellite = {
    Unit = {
      Description = "XWayland Satellite — X11 compat no Niri";
      After       = [ "niri.service" ];
      BindsTo     = [ "niri.service" ];
    };
    Service = {
      Type = "simple";
      Environment = [ "XAUTHORITY=%t/.Xauthority-xwayland" ];

      ExecStartPre = pkgs.writeShellScript "xwayland-satellite-pre" ''
        # Remove socket órfão de sessão anterior (impede criação de :1)
        rm -f /tmp/.X11-unix/X1

        # Aguarda WAYLAND_DISPLAY estar disponível no bus
        for i in $(seq 1 30); do
          WD=$(${pkgs.systemd}/bin/systemctl --user show-environment 2>/dev/null \
               | grep '^WAYLAND_DISPLAY=' | cut -d= -f2)
          [ -n "$WD" ] && export WAYLAND_DISPLAY="$WD" && break
          sleep 0.5
        done
        [ -z "$WAYLAND_DISPLAY" ] && {
          echo "xwayland-satellite: WAYLAND_DISPLAY indisponivel" >&2; exit 1
        }

        # Gera cookie MIT-MAGIC-COOKIE-1 para :1
        AUTHFILE="$XDG_RUNTIME_DIR/.Xauthority-xwayland"
        COOKIE=$(od -An -N16 -tx1 /dev/urandom | tr -d ' \n')
        ${pkgs.xorg.xauth}/bin/xauth -f "$AUTHFILE" add :1 . "$COOKIE"
      '';

      PassEnvironment = "WAYLAND_DISPLAY";
      ExecStart       = "${pkgs.xwayland-satellite}/bin/xwayland-satellite :1";

      ExecStartPost = pkgs.writeShellScript "xwayland-satellite-post" ''
        # Aguarda socket :1 e exporta DISPLAY + XAUTHORITY para toda a sessão
        AUTHFILE="$XDG_RUNTIME_DIR/.Xauthority-xwayland"
        for i in $(seq 1 20); do
          [ -S /tmp/.X11-unix/X1 ] && \
            ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd \
              DISPLAY=:1 \
              XAUTHORITY="$AUTHFILE" && \
            exit 0
          sleep 0.5
        done
        echo "xwayland-satellite: socket X1 nao apareceu" >&2; exit 1
      '';

      Restart    = "on-failure";
      RestartSec = "3s";
    };
    Install.WantedBy = [ "niri.service" ];
  };

  # ════════════════════════════════════════════════════════════════
  # OVERRIDES — serviços que conflitam com o Niri
  # ════════════════════════════════════════════════════════════════

  # picom não tem função no Wayland — niri faz compositing nativamente
  systemd.user.services.picom = {
    Unit.ConditionEnvironment = "!NIRI_SOCKET";
  };
  systemd.user.services."app-picom@autostart" = {
    Unit.ConditionEnvironment = "!NIRI_SOCKET";
  };

  # dunst conflita com as notificações do noctalia pelo D-Bus
  systemd.user.services.dunst = {
    Unit.Conflicts = "niri.service";
  };

  # portal-gnome conflita com portal-gtk para file chooser no Wayland
  systemd.user.services.xdg-desktop-portal-gnome = {
    Unit.ConditionEnvironment = "!NIRI_SOCKET";
  };
}
