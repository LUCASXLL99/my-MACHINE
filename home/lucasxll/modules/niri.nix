# home/lucasxll/modules/niri.nix
#
# Configuração completa do Niri para o usuário lucasxll.
# Inclui: config KDL do compositor, waybar, mako, fuzzel, hyprlock.
#
# Mudanças em relação à versão anterior:
#   • swaylock → hyprlock: suporte a blur, renderização GPU, animações
#   • keybind Mod+Shift+L atualizado para `hyprlock`
#   • xdg.configFile."hypr/hyprlock.conf" adicionado

{ config, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    # Noctalia substitui: waybar, mako, fuzzel, swww, hyprlock, swayidle
    # Mantidos como fallback de emergência (comentar após confirmar noctalia OK):
    waybar
    mako
    fuzzel
    swww
    hyprlock
    swayidle

    grim
    slurp
    wl-clipboard
    wlr-randr
  ];

  # ══════════════════════════════════════════════════════════════
  # NIRI — config principal (KDL)
  # ══════════════════════════════════════════════════════════════
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

    // ── OUTPUT (MONITOR) ────────────────────────────────────────────
    //
    // !! VERIFIQUE O NOME DO SEU OUTPUT PRIMEIRO:
    //    Execute dentro do Niri:  niri msg outputs
    //    Se nao for "eDP-1", troque aqui E em mouse-invert.nix (var outputName)
    //
    output "eDP-1" {
        scale 1.0
        transform "flipped"
    }

    // ── LAYOUT ──────────────────────────────────────────────────────
    layout {
        gaps 8
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
            active-color "#58a6ff"
            inactive-color "#30363d"
        }

        border {
            off
        }
        shadow {
            on
        }
    }

    // ── APARÊNCIA ────────────────────────────────────────────────────
    prefer-no-csd

    animations {
        slowdown 0.8
    }

    // ── VARIÁVEIS DE AMBIENTE ─────────────────────────────────────────
    environment {
        // ── PATH — causa raiz de tudo não abrir ──────────────────────
        // O SDDM inicia o niri com um PATH mínimo (/usr/bin:/bin).
        // Ele não carrega .zshrc, .profile nem o environment do home-manager.
        // Resultado: niri não acha wezterm, kitty, dolphin, rofi, fuzzel,
        //   android-studio, waybar — NADA. spawn "wezterm" silenciosamente falha.
        //
        // Fix: PATH explícito cobrindo:
        //   /run/current-system/sw/bin  → pacotes do sistema (nixos rebuild)
        //   /etc/profiles/per-user/lucasxll/bin → pacotes do home-manager
        //   /nix/var/nix/profiles/default/bin   → nix cli tools
        //   /usr/bin:/bin                        → binários base do Linux
        // /run/wrappers/bin DEVE vir primeiro: é onde ficam os binários com setuid
        // (sudo, dbus-daemon, etc.). A versão em /run/current-system/sw/bin/sudo
        // é um symlink para o nix store — o store é montado com nosuid, então
        // o bit setuid nunca é honrado lá. Sem /run/wrappers/bin antes, todo
        // terminal aberto pelo niri falha com "sudo must have setuid bit set".
        PATH "/run/wrappers/bin:/run/current-system/sw/bin:/etc/profiles/per-user/lucasxll/bin:/nix/var/nix/profiles/default/bin:/usr/local/bin:/usr/bin:/bin"

        // ── Qt — Wayland nativo para apps Qt6 (Dolphin, etc.) ────────
        // QT_QPA_PLATFORM=wayland: faz Qt6 usar o backend Wayland direto.
        // Dolphin é Qt6 no nixpkgs — sem isso ele tenta xcb e precisa de
        // DISPLAY (xwayland), o que causa delay ou falha silenciosa.
        QT_QPA_PLATFORM "wayland"

        // QT_QPA_PLATFORMTHEME foi REMOVIDO ("kde" causava crash silencioso):
        // o tema "kde" requer o plugin plasma-integration. Sem ele instalado
        // explicitamente, o Qt tenta carregar o plugin, falha, e o app
        // (Dolphin, etc.) fecha antes de mostrar qualquer janela.
        // O nixpkgs configura o tema certo automaticamente via wrapper do
        // pacote dolphin — não precisa setar aqui.

        ELECTRON_OZONE_PLATFORM_HINT "auto"

        // ── XWayland — garante DISPLAY para filhos do Niri ────────────
        // O xwayland-satellite sobe em :0. Sem declarar aqui, terminais
        // e launchers herdam o environment do compositor — que não tem
        // DISPLAY definido — e apps X11 (como o Android Studio/AWT) falham
        // com "cannot connect to X server".
        DISPLAY ":0"

        // ── Java / AWT / Android Studio ──────────────────────────────
        _JAVA_AWT_WM_NONREPARENTING "1"
    }

    // ── SCREENSHOTS ─────────────────────────────────────────────────
    screenshot-path "~/Pictures/Screenshots/Screenshot_%Y-%m-%d_%H-%M-%S.png"

    // ── STARTUP ─────────────────────────────────────────────────────
    // Ordem deliberada:
    //   t=0  → dbus env exportado ao systemd (waybar e applets dependem disso)
    //   t=0  → mako, swww iniciam (não dependem do dbus do compositor)
    //   t=2  → waybar sobe (já consegue reclamar StatusNotifierWatcher no D-Bus)
    //   t=2  → mouse-invert-y reiniciado como garantia (WantedBy já cuida do boot)
    //   t=5  → applets (blueman, nm-applet) sobem DEPOIS do waybar estar dono do watcher
    //
    // xwayland-satellite é gerenciado pelo systemd (serviço abaixo neste arquivo).
    // Ele exporta DISPLAY=:0 para o bus via ExecStartPost antes que qualquer app
    // X11 possa ser lançado. Não usar spawn-at-startup: não há garantia de ordem
    // e o DISPLAY chegava vazio ao systemd quando o Studio era aberto logo após login.
    //
    // NIRI_SOCKET: obrigatório para waybar, swayidle e mouse-invert-y.
    //   - waybar usa NIRI_SOCKET para conectar no IPC e mostrar workspaces/window
    //   - mouse-invert-y usa ConditionEnvironment=NIRI_SOCKET para só ativar no niri
    //   - sem ele o waybar sobe em branco (sem módulos niri funcionando)
    spawn-at-startup "sh" "-c" "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP NIRI_SOCKET"
    spawn-at-startup "sh" "-c" "sleep 2 && systemctl --user restart mouse-invert-y"
    spawn-at-startup "sh" "-c" "pkill mpris-proxy; mpris-proxy"
    // Noctalia: barra, launcher, notificações, wallpaper, idle e lock em t=2
    spawn-at-startup "sh" "-c" "sleep 2 && noctalia-shell"
    spawn-at-startup "sh" "-c" "sleep 5 && nm-applet --indicator"
    // Fallbacks (descomentar se noctalia não subir):
    // spawn-at-startup "mako"
    // spawn-at-startup "swww-daemon"
    // spawn-at-startup "sh" "-c" "wl-paste --watch cliphist store"
    // spawn-at-startup "sh" "-c" "sleep 5 && blueman-applet"

    // ── ATALHOS ─────────────────────────────────────────────────────
    binds {
        Mod+Return       { spawn "wezterm"; }
        Mod+T            { spawn "wezterm"; }
        Mod+Shift+Return { spawn "kitty"; }

        // ── LAUNCHERS ────────────────────────────────────────────────
        Mod+D       { spawn "noctalia-shell" "ipc" "call" "launcher" "toggle"; }
        Mod+Shift+D { spawn "sh" "-c" "fuzzel --dmenu"; }

        // Rofi é X11 — precisa de DISPLAY=:0 (xwayland-satellite) explícito.
        // Sem o DISPLAY forçado aqui, o rofi herdaria DISPLAY vazio do niri
        // e falharia silenciosamente (não aparece nenhuma janela, nenhum erro).
        // fuzzel é o launcher nativo Wayland preferido no niri,
        // mas o rofi continua disponível para compatibilidade.
        Mod+R { spawn "sh" "-c" "DISPLAY=:0 rofi -show drun"; }

        Mod+E { spawn "dolphin"; }

        // Android Studio — DISPLAY=:0 obrigatório (app X11/AWT no niri)
        Mod+A { spawn "sh" "-c" "DISPLAY=:0 _JAVA_AWT_WM_NONREPARENTING=1 android-studio"; }

        // ── PRODUTIVIDADE WAYLAND ────────────────────────────────────
        // ── SCREENSHOT ───────────────────────────────────────────────
        // Print       → screenshot NATIVO do niri (sem slurp, sem overlay, sem trava)
        //               Abre a UI de seleção integrada ao compositor.
        //               Salva em screenshot-path acima. Seguro: Esc fecha limpo.
        // Shift+Print → tela inteira via niri (também nativo, sem risco)
        // Ctrl+Print  → grim+slurp para copiar área direto ao clipboard
        //               "|| exit 0" garante que Esc fecha a overlay sem travar
        Print       { screenshot; }
        Shift+Print { screenshot-screen; }
        Ctrl+Print  { spawn "sh" "-c" "sel=$(slurp 2>/dev/null) || exit 0; grim -g \"$sel\" - | wl-copy"; }
        // Histórico de clipboard (cliphist) via fuzzel
        Mod+V       { spawn "noctalia-shell" "ipc" "call" "launcher" "toggleClipboard"; }

        Mod+W       { close-window; }
        Mod+Shift+Q { close-window; }

        // ── FOCO (hjkl) ──────────────────────────────────────────────
        Mod+H { focus-column-left; }
        Mod+L { focus-column-right; }
        Mod+J { focus-window-down; }
        Mod+K { focus-window-up; }

        Mod+Home { focus-column-first; }
        Mod+End  { focus-column-last; }

        // ── MOVER JANELA ─────────────────────────────────────────────
        Mod+Shift+H { move-column-left; }
        Mod+Shift+L { move-column-right; }
        Mod+Shift+J { move-window-down; }
        Mod+Shift+K { move-window-up; }

        // ── WORKSPACES ───────────────────────────────────────────────
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

        // ── LAYOUT ───────────────────────────────────────────────────
        Mod+F         { maximize-column; }
        Mod+Shift+F   { fullscreen-window; }
        Mod+Shift+T   { toggle-window-floating; }  // era Mod+T — liberado para o terminal
        Mod+Ctrl+R    { switch-preset-column-width; }

        Mod+Comma  { consume-window-into-column; }
        Mod+Period { expel-window-from-column; }

        // ── REDIMENSIONAR ────────────────────────────────────────────
        Mod+Alt+H { set-column-width  "-10%"; }
        Mod+Alt+L { set-column-width  "+10%"; }
        Mod+Alt+J { set-window-height "+10%"; }
        Mod+Alt+K { set-window-height "-10%"; }

        // Screenshots: usando grim+swappy (keybinds na seção de apps acima)

        // ── VOLUME ───────────────────────────────────────────────────
        XF86AudioRaiseVolume allow-when-locked=true { spawn "noctalia-shell" "ipc" "call" "volume" "increase"; }
        XF86AudioLowerVolume allow-when-locked=true { spawn "noctalia-shell" "ipc" "call" "volume" "decrease"; }
        XF86AudioMute        allow-when-locked=true { spawn "noctalia-shell" "ipc" "call" "volume" "muteOutput"; }

        // ── MÍDIA ─────────────────────────────────────────────────────
        XF86AudioPlay  { spawn "playerctl" "play-pause"; }
        XF86AudioPause { spawn "playerctl" "play-pause"; }
        XF86AudioNext  { spawn "playerctl" "next"; }
        XF86AudioPrev  { spawn "playerctl" "previous"; }

        // ── BRILHO ───────────────────────────────────────────────────
        XF86MonBrightnessUp   { spawn "brightnessctl" "set" "+10%"; }
        XF86MonBrightnessDown { spawn "brightnessctl" "set" "10%-"; }

        // ── TELA / MOUSE ─────────────────────────────────────────────
        Mod+F5 { spawn "niri-mirror"; }
        Mod+F6 { spawn "niri-reset"; }

        // ── LOCK SCREEN (hyprlock) ───────────────────────────────────
        // Anteriormente: swaylock --color 1a1b26 ...
        // Agora: hyprlock — blur nativo, renderização GPU, animações
        Mod+Ctrl+L { spawn "noctalia-shell" "ipc" "call" "lockScreen" "lock"; }
    }

    // ── REGRAS DE JANELA ────────────────────────────────────────────
    window-rule {
        match app-id="org.kde.dolphin"
        open-floating true
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
  '';

  # ══════════════════════════════════════════════════════════════
  # HYPRLOCK — lock screen (substituiu swaylock)
  #
  # Vantagens sobre o swaylock:
  #   • Blur de fundo via shader GLSL (GPU, sem impacto na CPU)
  #   • Animações de entrada/saída configuráveis
  #   • Input field com feedback visual moderno
  #   • Suporte a múltiplos monitores nativamente
  #   • Integra com hypridle para suspender após inatividade
  #
  # Configuração: Tokyo Night, fundo escuro + blur + ring azul
  # ══════════════════════════════════════════════════════════════
  xdg.configFile."hypr/hyprlock.conf".text = ''
    general {
        disable_loading_bar = false
        hide_cursor         = true
        grace               = 0
        no_fade_in          = false
    }

    background {
        monitor     =
        path        = screenshot  # captura a tela atual e aplica blur
        blur_passes = 3
        blur_size   = 8
        brightness  = 0.6
        contrast    = 1.0
        vibrancy    = 0.2
    }

    input-field {
        monitor         =
        size            = 300, 50
        outline_thickness = 2
        dots_size       = 0.33
        dots_spacing    = 0.15
        dots_center     = true
        outer_color     = rgb(30363d)
        inner_color     = rgb(1a1b26)
        font_color      = rgb(c0caf5)
        fade_on_empty   = true
        placeholder_text = <span foreground="##565f89">Senha...</span>
        hide_input      = false
        check_color     = rgb(7aa2f7)
        fail_color      = rgb(f7768e)
        fail_text       = <i>$FAIL <b>($ATTEMPTS)</b></i>
        fail_transition = 300
        capslock_color  = rgb(e0af68)
        halign          = center
        valign          = center
        position        = 0, -80
    }

    label {
        monitor   =
        text      = $TIME
        color     = rgba(c0caf5ff)
        font_size = 64
        font_family = JetBrainsMono Nerd Font
        halign    = center
        valign    = center
        position  = 0, 80
        shadow_passes = 2
        shadow_size   = 4
    }

    label {
        monitor   =
        text      = $DATE
        color     = rgba(9aa5ceff)
        font_size = 18
        font_family = JetBrainsMono Nerd Font
        halign    = center
        valign    = center
        position  = 0, 10
    }
  '';

  # ══════════════════════════════════════════════════════════════
  # WAYBAR
  # ══════════════════════════════════════════════════════════════
  xdg.configFile."waybar/config".text = ''
    {
        "layer": "top",
        "position": "top",
        "height": 36,
        "spacing": 4,

        "modules-left":   ["niri/workspaces", "niri/window"],
        "modules-center": ["clock"],
        "modules-right":  ["bluetooth", "pulseaudio", "network", "battery", "tray"],

        "niri/workspaces": {
            "format": "{index}",
            "active-only": false
        },

        "niri/window": {
            "max-length": 60
        },

        "clock": {
            "format": " {:%H:%M}",
            "format-alt": " {:%Y-%m-%d %H:%M}",
            "tooltip-format": "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>"
        },

        "bluetooth": {
            "format":          "󰂯 {status}",
            "format-connected":"󰂱 {device_alias}",
            "format-off":      "󰂲",
            "tooltip-format":  "{controller_alias}\t{controller_address}\n\n{num_connections} connected",
            "on-click":        "blueman-manager"
        },

        "pulseaudio": {
            "format": "{icon} {volume}%",
            "format-muted": "󰝟 muted",
            "format-icons": { "default": ["󰕿", "󰖀", "󰕾"] },
            "on-click": "pavucontrol",
            "scroll-step": 5
        },

        "network": {
            "format-wifi":        " {essid} ({signalStrength}%)",
            "format-ethernet":    "󰈀 {ipaddr}",
            "format-disconnected":"󰤭 offline",
            "tooltip-format":     "{ifname}: {ipaddr} via {gwaddr}"
        },

        "battery": {
            "states": { "warning": 30, "critical": 15 },
            "format":          "{icon} {capacity}%",
            "format-charging": "󰂄 {capacity}%",
            "format-full":     "󰁹 full",
            "format-icons":    ["󰁺","󰁻","󰁼","󰁽","󰁾","󰁿","󰂀","󰂁","󰂂","󰁹"]
        },

        "tray": {
            "spacing": 8,
            "icon-size": 16
        }
    }
  '';

  xdg.configFile."waybar/style.css".text = ''
    * {
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size: 13px;
        min-height: 0;
        border: none;
        border-radius: 0;
    }

    window#waybar {
        background-color: rgba(26, 27, 38, 0.92);
        border-bottom: 2px solid #30363d;
        color: #c0caf5;
    }

    #workspaces button {
        padding: 0 8px;
        color: #565f89;
        background: transparent;
        border-bottom: 2px solid transparent;
    }

    #workspaces button.active {
        color: #c0caf5;
        border-bottom: 2px solid #7aa2f7;
    }

    #workspaces button:hover {
        background: rgba(122, 162, 247, 0.1);
        color: #c0caf5;
    }

    #window {
        padding: 0 12px;
        color: #9aa5ce;
        font-style: italic;
    }

    #clock {
        padding: 0 12px;
        color: #c0caf5;
        font-weight: bold;
    }

    #pulseaudio,
    #network,
    #battery,
    #bluetooth,
    #tray {
        padding: 0 10px;
        color: #c0caf5;
    }

    #battery.warning  { color: #e0af68; }
    #battery.critical { color: #f7768e; }

    #pulseaudio.muted { color: #565f89; }

    tooltip {
        background: #1a1b26;
        border: 1px solid #30363d;
        border-radius: 4px;
    }
  '';

  # ══════════════════════════════════════════════════════════════
  # MAKO — notificações Wayland
  # ══════════════════════════════════════════════════════════════
  xdg.configFile."mako/config".text = ''
    anchor=top-right
    margin=10

    background-color=#1a1b26ee
    text-color=#c0caf5
    border-color=#30363d
    border-size=2
    border-radius=6
    width=320
    height=120
    padding=12

    font=JetBrainsMono Nerd Font 12

    default-timeout=5000
    ignore-timeout=1

    [urgency=high]
    border-color=#f7768e
    default-timeout=0
  '';

  # ══════════════════════════════════════════════════════════════
  # FUZZEL — launcher Wayland
  # ══════════════════════════════════════════════════════════════
  xdg.configFile."fuzzel/fuzzel.ini".text = ''
    [main]
    font=JetBrainsMono Nerd Font:size=13
    dpi-aware=yes
    width=35
    lines=10
    terminal=wezterm
    prompt=❯ 

    [colors]
    background=1a1b26f0
    text=c0caf5ff
    match=7aa2f7ff
    selection=364a82ff
    selection-text=c0caf5ff
    border=30363dff

    [border]
    width=2
    radius=6
  '';

  # ══════════════════════════════════════════════════════════════
  # WAYBAR — serviço systemd (não spawn-at-startup)
  # ══════════════════════════════════════════════════════════════
  # spawn-at-startup crasha silenciosamente: sem logs, sem restart.
  # Como serviço: journalctl --user -u waybar mostra o erro exato,
  # Restart=on-failure recupera de crashes transientes.
  #
  # After+BindsTo=niri.service: sobe junto com o niri (que já tem
  # NIRI_SOCKET no bus nesse ponto) e para automaticamente ao fechar a sessão.
  #
  systemd.user.services.waybar = {
    Unit = {
      Description = "Waybar — barra de status Wayland para Niri";
      After       = [ "niri.service" ];
      BindsTo     = [ "niri.service" ];
    };
    Service = {
      Type = "simple";
      # Waybar precisa de NIRI_SOCKET para os módulos niri/workspaces e
      # niri/window, e de WAYLAND_DISPLAY para o protocolo layer-shell.
      # Ambos já estão no bus quando niri.service está ativo.
      ExecStart = "${pkgs.waybar}/bin/waybar";
      Restart    = "on-failure";
      RestartSec = "3s";
    };
    Install.WantedBy = [ "niri.service" ];
  };

  # ══════════════════════════════════════════════════════════════
  # DUNST — parar na sessão niri
  # ══════════════════════════════════════════════════════════════
  # dunst.nix declara services.dunst.enable = true globalmente.
  # No niri, o mako é o daemon de notificações. Se dunst e mako
  # estiverem ativos ao mesmo tempo, ambos registram no D-Bus via
  # org.freedesktop.Notifications — quem chegou primeiro vence.
  # Dunst sobe via graphical-session.target (antes do niri), então
  # intercepta as notificações e o mako não recebe nada.
  #
  # Conflicts=niri.service: systemd para o dunst automaticamente
  # quando o niri.service sobe, deixando o mako como único daemon.
  #
  systemd.user.services.dunst = {
    Unit.Conflicts = "niri.service";
  };
  # ══════════════════════════════════════════════════════════════
  # picom.nix declara services.picom.enable = true globalmente.
  # Home-manager cria picom.service + XDG autostart para qualquer sessão.
  # No Niri (Wayland), picom não tem utilidade (o niri já faz compositing)
  # e causa dois problemas:
  #   1. app-picom@autostart.service falha (sem X11 disponível no início)
  #   2. Entra em loop Restart=on-failure, gerando ruído no journal
  #
  # Fix: ConditionEnvironment=!NIRI_SOCKET faz o systemd pular o serviço
  # quando estamos numa sessão niri. Em bspwm, NIRI_SOCKET não existe →
  # condição verdadeira → picom sobe normalmente.
  #
  systemd.user.services.picom = {
    Unit.ConditionEnvironment = "!NIRI_SOCKET";
  };

  # XDG autostart do picom — mesmo princípio
  # O home-manager cria app-picom@autostart.service via XDG.
  # Sobrescreve com a mesma condição para silenciar o erro no log.
  systemd.user.services."app-picom@autostart" = {
    Unit.ConditionEnvironment = "!NIRI_SOCKET";
  };

  # ── xdg-desktop-portal-gnome: desabilitar na sessão niri ──────
  # O gnome-keyring puxa o xdg-desktop-portal-gnome como dependência.
  # No niri, o portal gnome conflita com o gtk portal para file chooser
  # e pode responder requisições antes do gtk, causando dialogs que
  # não aparecem ou travam. Mascarar o serviço garante que só o
  # xdg-desktop-portal-gtk responde nas sessões niri/wayland.
  systemd.user.services.xdg-desktop-portal-gnome = {
    Unit.ConditionEnvironment = "!NIRI_SOCKET";
  };
  # ══════════════════════════════════════════════════════════════
  #
  # Race condition anterior: o serviço subia em graphical-session.target,
  # mas WAYLAND_DISPLAY só chegava ao bus via spawn-at-startup do niri
  # (que roda DEPOIS do target). Resultado: satellite falhava, Restart=on-failure
  # o recriava, mas nesse intervalo apps X11 não tinham DISPLAY.
  #
  # Fix: ExecStartPre espera até o WAYLAND_DISPLAY existir no bus antes de
  # lançar o satellite. Isso elimina a race condition sem precisar de sleep.
  #
  systemd.user.services.xwayland-satellite = {
    Unit = {
      Description   = "XWayland Satellite — compatibilidade X11 no Niri";
      Documentation = "https://github.com/Supreeeme/xwayland-satellite";
      # Roda depois do niri — nessa altura WAYLAND_DISPLAY já foi
      # exportado ao bus pelo spawn-at-startup do próprio niri.
      # NÃO usar ConditionEnvironment aqui: essa condição é avaliada
      # ANTES do ExecStartPre, no ambiente do systemd daemon — que ainda
      # não tem WAYLAND_DISPLAY nesse momento. Resultado: serviço skipado
      # silenciosamente e some do list-units por completo.
      After  = [ "niri.service" ];
      BindsTo = [ "niri.service" ];
    };

    Service = {
      Type = "simple";

      # Aguarda WAYLAND_DISPLAY estar no ambiente (exportado pelo niri
      # via dbus-update-activation-environment no spawn-at-startup).
      # Como BindsTo=niri.service, niri já está rodando aqui — o loop
      # normalmente termina na primeira iteração.
      ExecStartPre = pkgs.writeShellScript "wait-wayland-display" ''
        for i in $(seq 1 30); do
          WD=$(${pkgs.systemd}/bin/systemctl --user show-environment 2>/dev/null \
               | grep '^WAYLAND_DISPLAY=' | cut -d= -f2)
          if [ -n "$WD" ]; then
            export WAYLAND_DISPLAY="$WD"
            exit 0
          fi
          sleep 0.5
        done
        echo "xwayland-satellite: WAYLAND_DISPLAY nao disponivel em 15s" >&2
        exit 1
      '';

      # Passa WAYLAND_DISPLAY para o processo do satellite.
      PassEnvironment  = "WAYLAND_DISPLAY";
      ExecStart        = "${pkgs.xwayland-satellite}/bin/xwayland-satellite :0";

      # Depois que o socket aparecer, exporta DISPLAY=:0 ao bus do systemd
      # para que qualquer app lançado a partir daí (Android Studio, JetBrains,
      # etc.) já encontre DISPLAY definido.
      ExecStartPost = pkgs.writeShellScript "export-x11-display" ''
        for i in $(seq 1 20); do
          if [ -S /tmp/.X11-unix/X0 ]; then
            ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd DISPLAY=:0
            exit 0
          fi
          sleep 0.5
        done
        echo "xwayland-satellite: socket /tmp/.X11-unix/X0 nao apareceu em 10s" >&2
        exit 1
      '';

      Restart    = "on-failure";
      RestartSec = "3s";
    };

    # WantedBy=niri.service: sobe junto com o niri, para junto com o niri.
    Install.WantedBy = [ "niri.service" ];
  };

  # ══════════════════════════════════════════════════════════════
  # SWAYIDLE — gerenciamento de inatividade / suspensão
  # ══════════════════════════════════════════════════════════════
  #
  # Timings:
  #   5 min  → trava a tela com hyprlock
  #   6 min  → apaga o display via niri msg (DPMS off, economia imediata)
  #   10 min → suspende o sistema (systemctl suspend)
  #
  # before-sleep → trava a tela ANTES de suspender, independente do timer.
  # after-resume  → religa o display quando o sistema volta do suspend.
  #
  # O serviço herda WAYLAND_DISPLAY do graphical-session.target (populado
  # pelo niri), sem necessidade de hardcode.
  #
  # Para ajustar os tempos: edite os valores em segundos abaixo e
  # rode home-manager switch.
  #
  systemd.user.services.swayidle = {
    Unit = {
      Description = "Swayidle — idle inhibitor e gerenciador de suspensão";
      After       = [ "graphical-session.target" ];
      PartOf      = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = pkgs.lib.concatStringsSep " " [
        "${pkgs.swayidle}/bin/swayidle" "-w"
        "timeout" "300"  "'${pkgs.hyprlock}/bin/hyprlock'"
        "timeout" "360"  "'${pkgs.niri}/bin/niri msg action power-off-monitors'"
        "timeout" "600"  "'${pkgs.systemd}/bin/systemctl suspend'"
        "before-sleep"   "'${pkgs.hyprlock}/bin/hyprlock'"
        "after-resume"   "'${pkgs.niri}/bin/niri msg action power-on-monitors'"
      ];
      Restart    = "on-failure";
      RestartSec = "3s";
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
