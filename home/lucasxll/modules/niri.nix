# home/lucasxll/modules/niri.nix
#
# Config do compositor Niri + serviços systemd de suporte.
#
# O noctalia-shell (noctalia.nix) substitui:
#   waybar, mako, fuzzel, swww, hyprlock, swayidle
# Este arquivo mantém APENAS:
#   • Config KDL do compositor
#   • xwayland-satellite (X11 compat)
#   • Overrides de serviços que conflitam com niri (picom, dunst, portal-gnome)

{ config, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    grim          # screenshot nativo Wayland
    slurp         # seleção de área (Ctrl+Print)
    wl-clipboard  # wl-copy / wl-paste
    wlr-randr     # controle de output (niri-mirror / niri-reset)
    xorg.xauth    # geração de cookie MIT-MAGIC-COOKIE para xwayland-satellite
    xdotool       # leitura de posição do cursor via X11 (hot-corner.nix)
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
        // transform "normal"  // padrão — sem espelho no boot
        // use niri-mirror (Mod+F5) para ativar o espelho quando quiser
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
      // Desativa animação de abertura: janela não aparece na direita
      // antes do niri-autoplace movê-la para a esquerda.
      window-open { off; }
      // Desativa animação de movimento horizontal de colunas/viewport.
      // Sem isso, o move-column-to-first do niri-autoplace causa um
      // deslize visível da direita para a esquerda após a abertura.
      // Com off, o movimento é instantâneo — janela teleporta para
      // a primeira posição sem nenhum flash ou slide perceptível.
      // Navegação normal (Mod+H/S) também fica instantânea.
      horizontal-view-movement { off; }
    }

    hotkey-overlay {
        skip-at-startup
    }

    // ── AMBIENTE ───────────────────────────────────────────────────
    environment {
        // /run/wrappers/bin PRIMEIRO: sudo e outros setuid ficam aqui.
        // A versão em /run/current-system/sw/bin é symlink para o nix store,
        // que é montado com nosuid — o bit setuid não é honrado lá.
        PATH "/run/wrappers/bin:/run/current-system/sw/bin:/etc/profiles/per-user/lucasxll/bin:/nix/var/nix/profiles/default/bin:/usr/local/bin:/usr/bin:/bin"

        QT_QPA_PLATFORM "wayland"
        ELECTRON_OZONE_PLATFORM_HINT "auto"

        // DISPLAY fixo: xwayland-satellite sobe em :1 (:0 é ocupado pelo SDDM)
        DISPLAY ":1"

        // Java/AWT — Android Studio
        _JAVA_AWT_WM_NONREPARENTING "1"
    }

    screenshot-path "~/Pictures/Screenshots/Screenshot_%Y-%m-%d_%H-%M-%S.png"

    // ── STARTUP ────────────────────────────────────────────────────
    // Ordem:
    //   t=0 → dbus env exportado (noctalia, xwayland precisam de WAYLAND_DISPLAY)
    //   t=0 → mpris-proxy (controle de mídia via MPRIS)
    //   t=2 → mouse-invert-y restart (garante dispositivos [inv] com udev carregado)
    //   t=2 → noctalia-shell (barra, notif, wallpaper, lock, idle, luz noturna)
    //   t=5 → nm-applet (tray de rede avançada — VPN, etc.)
    //
    // waybar, xwayland-satellite → serviços systemd (logs, restart automático)
    // swayidle → REMOVIDO: noctalia gerencia idle/suspend via D-Bus loginctl
    //            (swayidle chamava systemctl suspend diretamente, bypassava
    //             inibidores do logind → tela vermelha/congelada após resume)
    spawn-at-startup "sh" "-c" "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP NIRI_SOCKET"
    spawn-at-startup "sh" "-c" "pkill mpris-proxy; mpris-proxy"
    spawn-at-startup "sh" "-c" "sleep 2 && systemctl --user restart mouse-invert-y"
    spawn-at-startup "sh" "-c" "sleep 2 && noctalia-shell"
    // cliphist iniciado via systemd (clipboard.nix) — sem spawn aqui
    spawn-at-startup "sh" "-c" "sleep 5 && nm-applet --indicator"
    spawn-at-startup "sh" "-c" "sleep 5 && systemctl --user start niri-blueman-applet"
    // wallpaper → gerenciado por systemd (home/lucasxll/modules/wallpaper.nix)
    //             systemctl --user status mpvpaper

    // ── ATALHOS ────────────────────────────────────────────────────
    binds {
        // Terminais
        // niri-autoplace cuida de mover para a esquerda — keybinds simples
        Mod+Return       { spawn "wezterm"; }
        Mod+T            { spawn "wezterm"; }
        Mod+Shift+Return { spawn "kitty"; }

        // Launchers
        Mod+D { spawn "noctalia-shell" "ipc" "call" "launcher" "toggle"; }
        Mod+R { spawn "sh" "-c" "DISPLAY=:1 rofi -show drun"; }

        // Apps
        // niri-autoplace move automaticamente qualquer janela nova para a esquerda.
        // Mod+A aguarda o socket X1 estar disponível antes de lançar o Studio
        // (evita race condition se xwayland-satellite ainda estiver subindo).
        Mod+E { spawn "dolphin"; }
        Mod+B { spawn "blueman-manager"; }     // gerenciador Bluetooth
        Mod+A { spawn "sh" "-c" "for i in $(seq 1 20); do [ -S /tmp/.X11-unix/X1 ] && break; sleep 0.5; done; android-studio"; }

        // Clipboard
        Mod+V { spawn "sh" "-c" "cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"; }

        // Screenshot
        // Print/Shift+Print → nativo do niri (sem slurp, sem overlay, sem trava)
        // Ctrl+Print → grim+slurp com "|| exit 0" (Esc fecha limpo)
        Print       { screenshot; }
        Shift+Print { screenshot-screen; }
        Ctrl+Print  { spawn "sh" "-c" "sel=$(slurp 2>/dev/null) || exit 0; grim -g \"$sel\" - | wl-copy"; }

        // Lock
        Mod+Ctrl+L { spawn "noctalia-shell" "ipc" "call" "lockScreen" "lock"; }

        // Sessão
        Mod+Shift+P { spawn "noctalia-shell" "ipc" "call" "sessionMenu" "toggle"; }

        // Volume — IPC noctalia (OSD integrado)
        XF86AudioRaiseVolume allow-when-locked=true { spawn "noctalia-shell" "ipc" "call" "volume" "increase"; }
        XF86AudioLowerVolume allow-when-locked=true { spawn "noctalia-shell" "ipc" "call" "volume" "decrease"; }
        XF86AudioMute        allow-when-locked=true { spawn "noctalia-shell" "ipc" "call" "volume" "muteOutput"; }

        // Mídia
        XF86AudioPlay  { spawn "playerctl" "play-pause"; }
        XF86AudioPause { spawn "playerctl" "play-pause"; }
        XF86AudioNext  { spawn "playerctl" "next"; }
        XF86AudioPrev  { spawn "playerctl" "previous"; }

        // Brilho
        XF86MonBrightnessUp   { spawn "brightnessctl" "set" "+10%"; }
        XF86MonBrightnessDown { spawn "brightnessctl" "set" "10%-"; }

        // Tela
        Mod+F5 { spawn "niri-mirror"; }
        Mod+F6 { spawn "niri-reset"; }

        // Fechar
        Mod+W         { close-window; }
        Mod+Semicolon { spawn "sh" "-c" "pkill mpvpaper || mpvpaper -o 'no-audio loop' '*' ~/Pictures/wallpapers/wallpaper.mp4"; }
        Mod+Shift+Q { close-window; }

        // Foco (hjkl)
        Mod+H { focus-column-right; }
        Mod+S { focus-column-left; }
        Mod+J { focus-window-down; }
        Mod+K { focus-window-up; }
        Mod+Home { focus-column-first; }
        Mod+End  { focus-column-last; }

        // Mover
        Mod+Shift+H { move-column-left; }
        Mod+Shift+L { move-column-right; }
        Mod+Shift+J { move-window-down; }
        Mod+Shift+K { move-window-up; }

        // Workspaces
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

        // Layout
        Mod+F         { maximize-column; }
        Mod+Shift+F   { fullscreen-window; }
        Mod+M         { toggle-window-floating; }
        Mod+Shift+T   { toggle-window-floating; }
        Mod+Ctrl+R    { switch-preset-column-width; }
        Mod+Comma     { consume-window-into-column; }
        Mod+Period    { expel-window-from-column; }

        // Redimensionar
        Mod+Alt+H { set-column-width  "-10%"; }
        Mod+Alt+L { set-column-width  "+10%"; }
        Mod+Alt+J { set-window-height "+10%"; }
        Mod+Alt+K { set-window-height "-10%"; }
        // Floating
        Mod+Shift+V { switch-focus-between-floating-and-tiling; }

        // Coluna
        Mod+C         { center-column; }
        Mod+Ctrl+F    { expand-column-to-available-width; }
        Mod+BracketLeft  { consume-or-expel-window-left; }
        Mod+BracketRight { consume-or-expel-window-right; }

        // Workspaces — aliases U/I (alternativa a Ctrl+J/K)
        Mod+U              { focus-workspace-down; }
        Mod+I              { focus-workspace-up; }
        Mod+Page_Down      { focus-workspace-down; }
        Mod+Page_Up        { focus-workspace-up; }
        Mod+Ctrl+U         { move-column-to-workspace-down; }
        Mod+Ctrl+I         { move-column-to-workspace-up; }
        Mod+Shift+Page_Down { move-workspace-down; }
        Mod+Shift+Page_Up   { move-workspace-up; }

        // Scroll do mouse com Mod
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
    // Dolphin abre em modo tiling (remover open-floating true)
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
    window-rule {
        match app-id=r#"firefox$"# title="^Picture-in-Picture$"
        open-floating true
    }
  '';

  # ════════════════════════════════════════════════════════════════
  # NIRI-AUTOPLACE — move QUALQUER janela nova para a esquerda
  # ════════════════════════════════════════════════════════════════
  #
  # Serviço universal: qualquer janela tiling nova que abrir focada é
  # movida para a esquerda automaticamente — sem lista de apps.
  #
  # Janelas floating (pavucontrol, copyq, diálogos, etc.) são ignoradas
  # via filtro is_floating no jq.
  #
  # Cada janela é rastreada pelo ID numérico em $SEEN (tmpdir).
  # Isso garante que a janela seja movida só uma vez — re-focar a mesma
  # janela não dispara um segundo move-column-to-first.
  #
  # Para descobrir o app_id de qualquer janela:
  #   niri msg --json windows | jq '.[].app_id'
  systemd.user.services.niri-autoplace = {
    Unit = {
      Description = "Niri auto-place — move qualquer janela nova para a primeira posição";
      After       = [ "niri.service" ];
      BindsTo     = [ "niri.service" ];
    };
    Service = {
      Type    = "simple";
      Restart = "on-failure";
      RestartSec = "2s";
      ExecStart = pkgs.writeShellScript "niri-autoplace" ''
        # Aguarda o socket do niri estar disponível
        for i in $(seq 1 20); do
          [ -n "$NIRI_SOCKET" ] && break
          NIRI_SOCKET=$(${pkgs.systemd}/bin/systemctl --user show-environment 2>/dev/null \
            | grep '^NIRI_SOCKET=' | cut -d= -f2)
          sleep 0.5
        done
        [ -z "$NIRI_SOCKET" ] && { echo "niri-autoplace: NIRI_SOCKET não encontrado" >&2; exit 1; }
        export NIRI_SOCKET

        echo "niri-autoplace: monitorando TODAS as janelas em $NIRI_SOCKET"

        # Diretório temporário para rastrear IDs já processados.
        # Cada janela nova ganha um arquivo vazio com seu ID como nome.
        # Re-focar a mesma janela não dispara move-column-left novamente.
        SEEN=$(mktemp -d /tmp/niri-autoplace-XXXXXX)
        trap 'rm -rf "$SEEN"' EXIT INT TERM

        # Escuta eventos e age sobre WindowOpenedOrChanged não-floating.
        # NÃO filtra is_focused: apps X11/XWayland (Android Studio, etc.)
        # recebem foco num evento separado e nunca passariam por esse filtro.
        # O ID tracking abaixo garante que cada janela é movida só uma vez.
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

              # Processa cada janela apenas uma vez (na abertura)
              if [ ! -f "$SEEN/$wid" ]; then
                touch "$SEEN/$wid"
                ${pkgs.niri}/bin/niri msg action move-column-to-first
                echo "niri-autoplace: moveu '$app_id' (id=$wid) para a primeira posição"
              fi
            done
      '';
    };
    Install.WantedBy = [ "niri.service" ];
  };

  # ════════════════════════════════════════════════════════════════
  # BLUETOOTH — applet de tray para niri
  # ════════════════════════════════════════════════════════════════
  # Iniciado via spawn-at-startup (não via WantedBy) — só ativo no niri.
  # Para abrir o manager: Mod+B  ou  blueman-manager no terminal.
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
    # Sem WantedBy: iniciado pelo spawn-at-startup do niri config.
    # bspwm usa seu próprio serviço bspwm-blueman.
  };

  # ════════════════════════════════════════════════════════════════
  # XWAYLAND-SATELLITE — X11 no Niri
  # ════════════════════════════════════════════════════════════════
  systemd.user.services.xwayland-satellite = {
    Unit = {
      Description = "XWayland Satellite — X11 compat no Niri";
      After       = [ "niri.service" ];
      BindsTo     = [ "niri.service" ];
    };
    Service = {
      Type = "simple";

      # XAUTHORITY fixo no runtime dir do usuário.
      # Precisa estar no Environment do service para que o xwayland-satellite
      # passe o flag -auth para o Xwayland interno, e para que ExecStartPost
      # consiga ler $XDG_RUNTIME_DIR com o valor correto.
      Environment = [ "XAUTHORITY=%t/.Xauthority-xwayland" ];

      ExecStartPre = pkgs.writeShellScript "xwayland-satellite-pre" ''
        # ── 1. Remove socket órfão de sessão anterior ─────────────────
        # O Xwayland não consegue criar :1 se o arquivo já existe.
        # Isso acontece quando a sessão anterior foi encerrada sem cleanup.
        rm -f /tmp/.X11-unix/X1

        # ── 2. Aguarda WAYLAND_DISPLAY estar disponível ───────────────
        for i in $(seq 1 30); do
          WD=$(${pkgs.systemd}/bin/systemctl --user show-environment 2>/dev/null \
               | grep '^WAYLAND_DISPLAY=' | cut -d= -f2)
          [ -n "$WD" ] && export WAYLAND_DISPLAY="$WD" && break
          sleep 0.5
        done
        [ -z "$WAYLAND_DISPLAY" ] && {
          echo "xwayland-satellite: WAYLAND_DISPLAY indisponivel" >&2; exit 1
        }

        # ── 3. Gera cookie MIT-MAGIC-COOKIE-1 para :1 ────────────────
        # Sem isso, todo cliente X11 recebe "Authorization required".
        # O cookie é aleatório e vale só para a sessão atual.
        AUTHFILE="$XDG_RUNTIME_DIR/.Xauthority-xwayland"
        COOKIE=$(od -An -N16 -tx1 /dev/urandom | tr -d ' \n')
        ${pkgs.xorg.xauth}/bin/xauth -f "$AUTHFILE" add :1 . "$COOKIE"
        echo "xwayland-satellite: auth cookie gerado em $AUTHFILE"
      '';

      PassEnvironment = "WAYLAND_DISPLAY";
      ExecStart       = "${pkgs.xwayland-satellite}/bin/xwayland-satellite :1";

      ExecStartPost = pkgs.writeShellScript "xwayland-satellite-post" ''
        # Aguarda o socket :1 aparecer, depois exporta DISPLAY e XAUTHORITY
        # para toda a sessão via dbus/systemd.
        # Sem exportar XAUTHORITY, apps como Android Studio não encontram
        # o cookie e falham com "Authorization required".
        AUTHFILE="$XDG_RUNTIME_DIR/.Xauthority-xwayland"
        for i in $(seq 1 20); do
          [ -S /tmp/.X11-unix/X1 ] && \
            ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd \
              DISPLAY=:1 \
              XAUTHORITY="$AUTHFILE" && \
            echo "xwayland-satellite: DISPLAY=:1 XAUTHORITY=$AUTHFILE exportados" && \
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

  # dunst briga com as notificações do noctalia pelo D-Bus
  systemd.user.services.dunst = {
    Unit.Conflicts = "niri.service";
  };

  # portal-gnome conflita com portal-gtk para file chooser no Wayland
  systemd.user.services.xdg-desktop-portal-gnome = {
    Unit.ConditionEnvironment = "!NIRI_SOCKET";
  };
}
