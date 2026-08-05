{ config, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    grim slurp
    wl-clipboard
    wlr-randr
    xorg.xauth
  ];

  xdg.configFile."niri/config.kdl".text = ''
    // ── INPUT ──────────────────────────────────────────────────────
    input {
        keyboard {
            xkb {
                // Fixo em "us": o teclado custom (QMK) já remapeia tudo no
                // próprio firmware, então a camada BASE não depende do
                // layout do SO — mas os símbolos da camada SYM (KC_SLSH,
                // KC_SCLN, etc.) são posições físicas ANSI US. Com o SO em
                // "br"/nodeadkeys, a tradução posição→caractere não batia
                // com o que o firmware espera (ex: "/" saindo como ";").
                // Antes: layout "br"; variant "nodeadkeys";
                layout "us"
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
      // off: janela não aparece à direita antes do niri-autoplace movê-la.
      window-open { off; }
      // off: evita slide visível ao mover coluna para a primeira posição.
      // Navegação normal (Mod+H/S) também fica instantânea.
      horizontal-view-movement { off; }
    }

    hotkey-overlay {
        skip-at-startup
    }

    // ── AMBIENTE ───────────────────────────────────────────────────
    environment {
        // /run/wrappers/bin primeiro: sudo e outros setuid ficam aqui.
        // /run/current-system/sw/bin é nosuid — setuid não é honrado lá.
        PATH "/run/wrappers/bin:/run/current-system/sw/bin:/etc/profiles/per-user/lucasxll/bin:/nix/var/nix/profiles/default/bin:/usr/local/bin:/usr/bin:/bin"

        QT_QPA_PLATFORM "wayland"
        ELECTRON_OZONE_PLATFORM_HINT "auto"

        // :1 porque :0 é ocupado pelo SDDM
        DISPLAY ":1"

        _JAVA_AWT_WM_NONREPARENTING "1"
    }

    screenshot-path "~/Pictures/Screenshots/Screenshot_%Y-%m-%d_%H-%M-%S.png"

    // ── STARTUP ────────────────────────────────────────────────────
    // sleep 1: garante que o socket niri está pronto antes de exportar.
    spawn-at-startup "sh" "-c" "sleep 1 && dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP NIRI_SOCKET DISPLAY"
    spawn-at-startup "sh" "-c" "pkill mpris-proxy; mpris-proxy"
    spawn-at-startup "sh" "-c" "sleep 2 && systemctl --user restart mouse-invert-y"
    spawn-at-startup "sh" "-c" "sleep 5 && nm-applet --indicator"
    spawn-at-startup "sh" "-c" "sleep 5 && systemctl --user start niri-blueman-applet"
    // Sem sessão Plasma, não há kded rodando pra manter o ksycoca em dia —
    // sem isso, "Abrir com" no Dolphin fica sem listar nenhum app instalado.
    spawn-at-startup "sh" "-c" "sleep 2 && kbuildsycoca6 --noincremental"
    // noctalia-shell, copyq, mpvpaper, xwayland-satellite → serviços systemd

    // ── ATALHOS ────────────────────────────────────────────────────
    binds {
        Mod+Return       { spawn "wezterm"; }
        Mod+T            { spawn "wezterm"; }
        Mod+Shift+Return { spawn "kitty"; }

        Mod+D { spawn "noctalia-shell" "ipc" "call" "launcher" "toggle"; }
        Mod+R { spawn "sh" "-c" "DISPLAY=:1 rofi -show drun"; }

        Mod+E { spawn "dolphin"; }
        Mod+B { spawn "blueman-manager"; }
        // Aguarda socket X1 antes de lançar (xwayland-satellite pode ainda estar subindo)
        Mod+A { spawn "sh" "-c" "for i in $(seq 1 20); do [ -S /tmp/.X11-unix/X1 ] && break; sleep 0.5; done; android-studio"; }

        Mod+V { spawn "copyq" "show"; }

        // Extrai zip/tar/rar/7z do item selecionado na janela ativa do
        // Dolphin (ver home/lucasxll/modules/wayland/dolphin-extract.nix)
        Ctrl+Alt+E { spawn "dolphin-extract-selected"; }

        Print       { screenshot; }
        Shift+Print { screenshot-screen; }
        Ctrl+Print  { spawn "sh" "-c" "sel=$(slurp 2>/dev/null) || exit 0; grim -g \"$sel\" - | wl-copy"; }

        Mod+Ctrl+L  { spawn "noctalia-shell" "ipc" "call" "lockScreen" "lock"; }
        Mod+Shift+P { spawn "noctalia-shell" "ipc" "call" "sessionMenu" "toggle"; }

        XF86AudioRaiseVolume allow-when-locked=true { spawn "noctalia-shell" "ipc" "call" "volume" "increase"; }
        XF86AudioLowerVolume allow-when-locked=true { spawn "noctalia-shell" "ipc" "call" "volume" "decrease"; }
        XF86AudioMute        allow-when-locked=true { spawn "noctalia-shell" "ipc" "call" "volume" "muteOutput"; }

        XF86AudioPlay  { spawn "playerctl" "play-pause"; }
        XF86AudioPause { spawn "playerctl" "play-pause"; }
        XF86AudioNext  { spawn "playerctl" "next"; }
        XF86AudioPrev  { spawn "playerctl" "previous"; }

        XF86MonBrightnessUp   { spawn "brightnessctl" "set" "+10%"; }
        XF86MonBrightnessDown { spawn "brightnessctl" "set" "10%-"; }

        Mod+F5 { spawn "niri-mirror"; }
        Mod+F6 { spawn "niri-reset"; }

        Mod+W         { close-window; }
        Mod+Shift+Q   { close-window; }
        Mod+Semicolon { spawn "sh" "-c" "pkill mpvpaper || mpvpaper -o 'no-audio loop' '*' ~/Pictures/wallpapers/wallpaper.mp4"; }

        Mod+H    { focus-column-right; }
        Mod+S    { focus-column-left; }
        Mod+J    { focus-window-down; }
        Mod+K    { focus-window-up; }
        Mod+Home { focus-column-first; }
        Mod+End  { focus-column-last; }

        Mod+Shift+H { move-column-left; }
        Mod+Shift+L { move-column-right; }
        Mod+Shift+J { move-window-down; }
        Mod+Shift+K { move-window-up; }

        Mod+Ctrl+J       { focus-workspace-down; }
        Mod+Ctrl+K       { focus-workspace-up; }
        Mod+Ctrl+Shift+J { move-window-to-workspace-down; }
        Mod+Ctrl+Shift+K { move-window-to-workspace-up; }

        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }

        Mod+Shift+1 { move-window-to-workspace 1; }
        Mod+Shift+2 { move-window-to-workspace 2; }
        Mod+Shift+3 { move-window-to-workspace 3; }
        Mod+Shift+4 { move-window-to-workspace 4; }
        Mod+Shift+5 { move-window-to-workspace 5; }
        Mod+Shift+6 { move-window-to-workspace 6; }
        Mod+Shift+7 { move-window-to-workspace 7; }
        Mod+Shift+8 { move-window-to-workspace 8; }
        Mod+Shift+9 { move-window-to-workspace 9; }

        Mod+F       { maximize-column; }
        Mod+Shift+F { fullscreen-window; }
        Mod+M       { toggle-window-floating; }
        Mod+Shift+T { toggle-window-floating; }
        Mod+Ctrl+R  { switch-preset-column-width; }
        Mod+Comma   { consume-window-into-column; }
        Mod+Period  { expel-window-from-column; }

        Mod+Alt+H { set-column-width  "-10%"; }
        Mod+Alt+L { set-column-width  "+10%"; }
        Mod+Alt+J { set-window-height "+10%"; }
        Mod+Alt+K { set-window-height "-10%"; }

        Mod+Shift+V { switch-focus-between-floating-and-tiling; }

        Mod+C         { center-column; }
        Mod+Ctrl+F    { expand-column-to-available-width; }
        Mod+BracketLeft  { consume-or-expel-window-left; }
        Mod+BracketRight { consume-or-expel-window-right; }

        Mod+U         { focus-workspace-down; }
        Mod+I         { focus-workspace-up; }
        Mod+Page_Down { focus-workspace-down; }
        Mod+Page_Up   { focus-workspace-up; }
        Mod+Ctrl+U    { move-column-to-workspace-down; }
        Mod+Ctrl+I    { move-column-to-workspace-up; }
        Mod+Shift+Page_Down { move-workspace-down; }
        Mod+Shift+Page_Up   { move-workspace-up; }

        Mod+WheelScrollDown      cooldown-ms=150 { focus-column-right; }
        Mod+WheelScrollUp        cooldown-ms=150 { focus-column-left; }
        Mod+Ctrl+WheelScrollDown cooldown-ms=150 { focus-workspace-down; }
        Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { focus-workspace-up; }
        Mod+WheelScrollRight      { focus-column-right; }
        Mod+WheelScrollLeft       { focus-column-left; }
        Mod+Ctrl+WheelScrollRight { move-column-right; }
        Mod+Ctrl+WheelScrollLeft  { move-column-left; }
    }

    // ── WINDOW RULES ───────────────────────────────────────────────
    window-rule {
        match app-id="org.kde.dolphin"
    }
    window-rule {
        match app-id=r#".*[Bb]lueman.*"#
        open-floating true
    }
    window-rule {
        match app-id="pavucontrol"
        open-floating true
    }
    window-rule {
        match app-id="copyq"
        open-floating true
    }
    window-rule {
        match title="^Picture-in-Picture$"
        open-floating true
    }
    window-rule {
        match app-id=r#"firefox$"# title="^Picture-in-Picture$"
        open-floating true
    }

    // ── EFEITOS VISUAIS ────────────────────────────────────────────
    window-rule {
        geometry-corner-radius 20
        clip-to-geometry true
    }
    window-rule {
        opacity 0.96
    }
    window-rule {
        draw-border-with-background false
    }
  '';

  # ── NIRI-AUTOPLACE ─────────────────────────────────────────────────────────
  # Move qualquer janela tiling nova para a primeira posição automaticamente.
  # Janelas floating são ignoradas via filtro is_floating.
  # Cada janela é rastreada pelo ID em $SEEN para ser movida só uma vez.
  systemd.user.services.niri-autoplace = {
    Unit = {
      Description = "Niri autoplace — move janelas novas para a primeira posição";
      After       = [ "niri.service" ];
      BindsTo     = [ "niri.service" ];
    };
    Service = {
      Type       = "simple";
      Restart    = "on-failure";
      RestartSec = "2s";
      ExecStart  = pkgs.writeShellScript "niri-autoplace" ''
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
                echo "niri-autoplace: '$app_id' (id=$wid)"
              fi
            done
      '';
    };
    Install.WantedBy = [ "niri.service" ];
  };

  # ── BLUETOOTH APPLET ───────────────────────────────────────────────────────
  # Sem WantedBy: iniciado pelo spawn-at-startup do niri.
  systemd.user.services.niri-blueman-applet = {
    Unit = {
      Description = "Blueman applet (niri)";
      After       = [ "graphical-session.target" ];
      PartOf      = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart  = "${pkgs.blueman}/bin/blueman-applet";
      Restart    = "on-failure";
      RestartSec = "3s";
    };
  };

  # ── XWAYLAND-SATELLITE ─────────────────────────────────────────────────────
  systemd.user.services.xwayland-satellite = {
    Unit = {
      Description = "XWayland Satellite — X11 compat no Niri";
      After       = [ "niri.service" ];
      BindsTo     = [ "niri.service" ];
    };
    Service = {
      Type = "simple";
      # XAUTHORITY fixo no runtime dir: ExecStartPost usa o mesmo valor.
      Environment = [ "XAUTHORITY=%t/.Xauthority-xwayland" ];

      ExecStartPre = pkgs.writeShellScript "xwayland-satellite-pre" ''
        # Remove socket órfão de sessão anterior (Xwayland não sobe em :1 se já existir)
        rm -f /tmp/.X11-unix/X1

        for i in $(seq 1 30); do
          WD=$(${pkgs.systemd}/bin/systemctl --user show-environment 2>/dev/null \
               | grep '^WAYLAND_DISPLAY=' | cut -d= -f2)
          [ -n "$WD" ] && export WAYLAND_DISPLAY="$WD" && break
          sleep 0.5
        done
        [ -z "$WAYLAND_DISPLAY" ] && {
          echo "xwayland-satellite: WAYLAND_DISPLAY indisponivel" >&2; exit 1
        }

        # Gera cookie MIT-MAGIC-COOKIE-1 para :1 (sem isso clientes X11 recebem auth error)
        AUTHFILE="$XDG_RUNTIME_DIR/.Xauthority-xwayland"
        COOKIE=$(od -An -N16 -tx1 /dev/urandom | tr -d ' \n')
        ${pkgs.xorg.xauth}/bin/xauth -f "$AUTHFILE" add :1 . "$COOKIE"
      '';

      PassEnvironment = "WAYLAND_DISPLAY";
      ExecStart       = "${pkgs.xwayland-satellite}/bin/xwayland-satellite :1";

      ExecStartPost = pkgs.writeShellScript "xwayland-satellite-post" ''
        # Aguarda socket :1 e exporta DISPLAY + XAUTHORITY para a sessão
        AUTHFILE="$XDG_RUNTIME_DIR/.Xauthority-xwayland"
        for i in $(seq 1 20); do
          [ -S /tmp/.X11-unix/X1 ] && \
            ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd \
              DISPLAY=:1 \
              XAUTHORITY="$AUTHFILE" && \
            exit 0
          sleep 0.5
        done
        echo "xwayland-satellite: socket X1 não apareceu" >&2; exit 1
      '';

      Restart    = "on-failure";
      RestartSec = "3s";
    };
    Install.WantedBy = [ "niri.service" ];
  };

  # ── PORTAL FIX (screencast) ─────────────────────────────────────────────────
  # Bug conhecido do niri: mesmo com tudo certo (xdg-desktop-portal-gnome
  # funcionando, ScreenCast roteado pra "gnome"), às vezes o
  # xdg-desktop-portal.service "trava" a interface ScreenCast como
  # indisponível se ele subiu antes do -gnome estar pronto na sessão. O fix
  # conhecido da comunidade (github niri-wm/niri#2399) é parar os 3 portals
  # envolvidos e subir 2 de volta, nessa ordem. Fazemos isso automaticamente
  # toda vez que o niri inicia, pra nunca mais depender de rodar isso na mão
  # antes de uma gravação/demo pro cliente.
  systemd.user.services.niri-portal-fix = {
    Unit = {
      Description = "Corrige bug do niri onde o portal de ScreenCast não sobe certo";
      After       = [ "niri.service" "xdg-desktop-portal.service" "xdg-desktop-portal-gnome.service" ];
      BindsTo     = [ "niri.service" ];
    };
    Service = {
      Type      = "oneshot";
      ExecStart = pkgs.writeShellScript "niri-portal-fix" ''
        set -e
        systemctl --user stop \
          xdg-desktop-portal.service \
          xdg-desktop-portal-gnome.service \
          xdg-desktop-portal-gtk.service 2>/dev/null || true
        sleep 1
        systemctl --user start xdg-desktop-portal-gnome.service
        sleep 1
        systemctl --user start xdg-desktop-portal.service
      '';
    };
    Install.WantedBy = [ "niri.service" ];
  };

  # ── OVERRIDES ──────────────────────────────────────────────────────────────
  # IMPORTANTE: `systemd.user.services.<nome> = { ... }` no Home Manager GERA
  # o unit inteiro do zero — não é um "acrescenta uma opção", é "substitui o
  # arquivo de serviço inteiro". Como esses três units vêm de pacotes (picom,
  # dunst, xdg-desktop-portal-gnome) e já têm seu próprio ExecStart=, usar essa
  # opção apagava o ExecStart= original e o systemd recusava o unit ("Service
  # has no ExecStart=... Refusing"). Isso quebrava silenciosamente o portal de
  # ScreenCast (OBS não conseguia oferecer captura de tela).
  # Fix: usar drop-ins de verdade (.service.d/override.conf), que só
  # sobrescrevem a diretiva indicada e preservam o resto do unit original.
  xdg.configFile."systemd/user/picom.service.d/override.conf".text = ''
    [Unit]
    ConditionEnvironment=!NIRI_SOCKET
  '';
  xdg.configFile."systemd/user/app-picom@autostart.service.d/override.conf".text = ''
    [Unit]
    ConditionEnvironment=!NIRI_SOCKET
  '';
  xdg.configFile."systemd/user/dunst.service.d/override.conf".text = ''
    [Unit]
    Conflicts=niri.service
  '';
  xdg.configFile."systemd/user/xdg-desktop-portal-gnome.service.d/override.conf".text = ''
    [Unit]
    # Invertido antes (!NIRI_SOCKET desligava o serviço justo quando o niri
    # está ativo). O portal-gnome é quem expõe a interface de ScreenCast que
    # o niri simula (org.gnome.Mutter.ScreenCast) — ele precisa rodar COM o
    # niri, não sem ele.
    ConditionEnvironment=NIRI_SOCKET
  '';
}
