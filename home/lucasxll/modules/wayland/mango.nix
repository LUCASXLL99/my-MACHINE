# ─────────────────────────────────────────────────────────────────────────
# mango.nix — PORTADO de niri.nix (ver histórico do repo pra comparar).
#
# Migração niri → mango: são paradigmas de tiling diferentes. niri é
# "colunas roláveis" (scrolling columns); mango é tags estilo dwm (como
# workspaces numerados 1-9, mas fixos por tag, não uma linha rolável).
# Isso significa que uma parte dos binds do niri (mexer com "colunas",
# "consumir/expelir janela da coluna", largura de coluna em %) NÃO TEM
# equivalente direto no mango — foram *comentados* abaixo em vez de
# inventados, marcados com "SEM EQUIVALENTE".
#
# Também simplifiquei bastante coisa que só existia por causa de
# limitações específicas do niri:
#   - xwayland-satellite (niri não embute Xwayland, mango embute
#     nativamente — "Excellent xwayland support" na doc oficial) → REMOVIDO
#   - o hack de DISPLAY=":1" e o socket X1 manual → REMOVIDO (Xwayland
#     nativo do mango cuida disso sozinho)
#   - niri-autoplace (mover toda janela nova pra primeira posição) → o
#     layout "tile" do mango (master-stack, como o dwm) já abre janelas
#     novas na posição master por padrão, então não portei esse serviço
#   - niri-portal-fix (bug específico do niri com o portal-gnome) →
#     REMOVIDO; o roteamento de portal do mango já foi resolvido em
#     hosts/nixos/default.nix (ScreenCast/RemoteDesktop → wlr, não gnome)
#
# Coisas que precisam de teste/ajuste ao vivo (não dá pra confirmar sem
# rodar no seu hardware):
#   - nomes exatos dos campos JSON do `mmsg get focusing-client`
#     (dolphin-extract.nix)
#   - `mmsg` glob do socket em hot-corner.nix
#   - alguns binds na seção "SEM EQUIVALENTE EXATO" abaixo (Home/End,
#     Comma/Period, etc.) são aproximações — testa e ajusta se ficar estranho
# ─────────────────────────────────────────────────────────────────────────

{ config, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    grim slurp
    wl-clipboard
    wlr-randr
  ];

  wayland.windowManager.mango = {
    enable = true;

    settings = {
      # ── INPUT ────────────────────────────────────────────────────────
      xkb_rules_layout          = "us"; # ver nota original: firmware QMK espera posições US
      repeat_delay               = 400;
      repeat_rate                 = 30;
      mouse_natural_scrolling      = 1;
      trackpad_natural_scrolling    = 1;
      tap_to_click                   = 1;
      disable_while_typing            = 1;

      # ── VISUAL — Tokyo Night, combinando com o Stylix/Noctalia ─────────
      gappih = 8; gappiv = 8; gappoh = 10; gappov = 10;
      borderpx    = 2;
      rootcolor   = "0x1a1b26ff"; # fundo do root, mesmo base00 do stylix
      bordercolor = "0x30363dff"; # inativa
      focuscolor  = "0x7aa2f7ff"; # ativa (azul tokyo night)
      urgentcolor = "0xf7768eff"; # vermelho tokyo night (base08)
      maximizescreencolor = "0x9ece6aff"; # verde (base0B)
      scratchpadcolor      = "0xbb9af7ff"; # roxo (base0E)

      border_radius = 14;
      no_radius_when_single = 1; # sem cantos redondos quando é a única janela — visual mais "cheio de tela"

      # blur otimizado (cacheia o wallpaper — muito mais leve na GPU
      # integrada do Ryzen 5700U que muito blur "de verdade")
      blur                    = 1;
      blur_optimized          = 1;
      blur_params_radius      = 6;
      blur_params_num_passes  = 2;
      blur_params_saturation  = 1.15; # levemente mais vivo, sem exagerar

      # sombra só em janelas flutuantes (blueman, pavucontrol, copyq, PiP)
      # — mantém as tiladas leves, sombra só ajuda a diferenciar o que tá
      # "por cima"
      shadows              = 1;
      shadow_only_floating = 1;
      shadows_size         = 12;
      shadows_blur         = 18;
      shadowscolor         = "0x00000088";

      focused_opacity   = 1.0;
      unfocused_opacity  = 0.94; # sutil, ajuda a achar a janela ativa sem ficar "piscando"

      animations              = 1;
      animation_type_open     = "none";  # equivalente ao "window-open { off; }" do niri
      animation_type_close    = "fade";
      animation_duration_open  = 200;
      animation_duration_close  = 250;

      cursor_theme = "Bibata-Modern-Classic";
      cursor_size  = 24;

      # ── ENV ──────────────────────────────────────────────────────────
      env = [
        "PATH,/run/wrappers/bin:/run/current-system/sw/bin:/etc/profiles/per-user/lucasxll/bin:/nix/var/nix/profiles/default/bin:/usr/local/bin:/usr/bin:/bin"
        "QT_QPA_PLATFORM,wayland"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "_JAVA_AWT_WM_NONREPARENTING,1"
      ];

      # ── AUTOSTART ────────────────────────────────────────────────────
      # NOTA: removi o dbus-update-activation-environment manual que tinha
      # aqui antes — o mango já faz isso sozinho via `systemd.enable`
      # (mango-session.target, ligado por padrão no módulo Home Manager),
      # e ter os dois rodando ao mesmo tempo cria uma corrida: o
      # noctalia-shell.service (que depende de graphical-session.target)
      # podia tentar subir antes do WAYLAND_DISPLAY estar de fato no bus,
      # e é bem provável que seja por isso que a barra sumiu.
      "exec-once" = [
        "sh -c \"pkill mpris-proxy; mpris-proxy\""
        "sh -c \"sleep 2 && systemctl --user restart mouse-invert-y\""
        "sh -c \"sleep 5 && nm-applet --indicator\""
        "sh -c \"sleep 5 && systemctl --user start mango-blueman-applet\""
        # Sem sessão Plasma, não há kded rodando pra manter o ksycoca em dia —
        # sem isso, "Abrir com" no Dolphin fica sem listar nenhum app instalado.
        "sh -c \"sleep 2 && kbuildsycoca6 --noincremental\""
      ];

      # ── ATALHOS ──────────────────────────────────────────────────────
      bind = [
        "SUPER,Return,spawn,wezterm"
        "SUPER,T,spawn,wezterm"
        "SUPER+SHIFT,Return,spawn,wezterm"

        "SUPER,D,spawn,noctalia-shell ipc call launcher toggle"
        "SUPER,R,spawn,rofi -show drun"
        "SUPER,Space,spawn,rofi -show drun"

        "SUPER,E,spawn,dolphin"
        "SUPER,B,spawn,blueman-manager"
        "SUPER,A,spawn,android-studio"

        "SUPER,V,spawn,copyq show"

        # Extrai zip/tar/rar/7z do item selecionado na janela ativa do
        # Dolphin (ver home/lucasxll/modules/wayland/dolphin-extract.nix)
        "CTRL+ALT,E,spawn,dolphin-extract-selected"

        "NONE,Print,spawn_shell,grim ~/Pictures/Screenshots/Screenshot_$(date +%Y-%m-%d_%H-%M-%S).png"
        "SHIFT,Print,spawn_shell,grim ~/Pictures/Screenshots/Screenshot_$(date +%Y-%m-%d_%H-%M-%S).png"
        "CTRL,Print,spawn_shell,sel=$(slurp 2>/dev/null) && grim -g \"$sel\" - | wl-copy"

        "SUPER+CTRL,L,spawn,noctalia-shell ipc call lockScreen lock"
        "SUPER+SHIFT,P,spawn,noctalia-shell ipc call sessionMenu toggle"

        "NONE,XF86AudioRaiseVolume,spawn,noctalia-shell ipc call volume increase"
        "NONE,XF86AudioLowerVolume,spawn,noctalia-shell ipc call volume decrease"
        "NONE,XF86AudioMute,spawn,noctalia-shell ipc call volume muteOutput"
        "SHIFT,XF86AudioMute,spawn,wpctl set-mute @DEFAULT_SOURCE@ toggle"

        "NONE,XF86AudioPlay,spawn,playerctl play-pause"
        "NONE,XF86AudioPause,spawn,playerctl play-pause"
        "NONE,XF86AudioNext,spawn,playerctl next"
        "NONE,XF86AudioPrev,spawn,playerctl previous"

        "NONE,XF86MonBrightnessUp,spawn,brightnessctl set +10%"
        "NONE,XF86MonBrightnessDown,spawn,brightnessctl set 10%-"

        "SUPER,F5,spawn,mango-mirror"
        "SUPER,F6,spawn,mango-reset"
        "SUPER,F7,spawn,mango-reload"
        "SUPER,F8,spawn,mango-screenshot"
        "SUPER,F9,spawn,mango-toggle-gaps"

        "SUPER,W,killclient"
        "SUPER+SHIFT,Q,killclient"
        "SUPER,Semicolon,spawn_shell,pkill mpvpaper || mpvpaper -o 'no-audio loop' '*' ~/Pictures/wallpapers/wallpaper.mp4"

        # focus (mantive o mapeamento H=direita / S=esquerda do niri original)
        "SUPER,H,focusdir,right"
        "SUPER,S,focusdir,left"
        "SUPER,J,focusdir,down"
        "SUPER,K,focusdir,up"

        "SUPER+SHIFT,H,exchange_client,left"
        "SUPER+SHIFT,L,exchange_client,right"
        "SUPER+SHIFT,J,exchange_client,down"
        "SUPER+SHIFT,K,exchange_client,up"

        "SUPER+CTRL,J,viewtoright"
        "SUPER+CTRL,K,viewtoleft"
        "SUPER+CTRL+SHIFT,J,tagtoright"
        "SUPER+CTRL+SHIFT,K,tagtoleft"

        "SUPER,1,view,1" "SUPER,2,view,2" "SUPER,3,view,3"
        "SUPER,4,view,4" "SUPER,5,view,5" "SUPER,6,view,6"
        "SUPER,7,view,7" "SUPER,8,view,8" "SUPER,9,view,9"

        "SUPER+SHIFT,1,tag,1" "SUPER+SHIFT,2,tag,2" "SUPER+SHIFT,3,tag,3"
        "SUPER+SHIFT,4,tag,4" "SUPER+SHIFT,5,tag,5" "SUPER+SHIFT,6,tag,6"
        "SUPER+SHIFT,7,tag,7" "SUPER+SHIFT,8,tag,8" "SUPER+SHIFT,9,tag,9"

        "SUPER,F,togglemaximizescreen"
        "SUPER+SHIFT,F,togglefullscreen"
        "SUPER,M,togglefloating"
        "SUPER+SHIFT,T,togglefloating"
        "SUPER+CTRL,R,switch_proportion_preset"

        "SUPER+ALT,H,setmfact,-0.05"
        "SUPER+ALT,L,setmfact,+0.05"

        "SUPER,C,centerwin"
        "SUPER,Tab,focuslast"
        "SUPER,G,toggleglobal"
        "SUPER+ALT,S,toggle_scratchpad"
        "SUPER,O,toggleoverview"

        "SUPER,U,viewtoright"
        "SUPER,I,viewtoleft"
        "SUPER,Page_Down,viewtoright"
        "SUPER,Page_Up,viewtoleft"
        "SUPER+CTRL,U,tagtoright"
        "SUPER+CTRL,I,tagtoleft"

        # SEM EQUIVALENTE EXATO no mango, mas mapeei pro mais próximo que
        # existe (em vez de deixar de fora) — testa e me fala se ficou
        # estranho, ajusto:
        "SUPER,Home,focusstack,prev"          # era focus-column-first
        "SUPER,End,focusstack,next"           # era focus-column-last
        "SUPER,Comma,groupjoin,left"          # era consume-window-into-column
        "SUPER,Period,groupleave"             # era expel-window-from-column
        "SUPER,BracketLeft,groupjoin,left"    # era consume-or-expel-window-left
        "SUPER+ALT,J,smartresizewin,down"     # era set-window-height (só afeta floating no mango)
        "SUPER+ALT,K,smartresizewin,up"
        "SUPER+SHIFT,V,toggle_all_floating"   # era switch-focus-between-floating-and-tiling (aproximado)
        "SUPER+CTRL,F,zoom"                   # era expand-column-to-available-width (aproximado: swap com master)

        # AINDA sem equivalente (não achei nenhum dispatch parecido, então
        # preferi não inventar):
        #   Mod+Shift+Page_Down/Up — reordenar a posição da tag/workspace
        #   em si (não é trocar de tag, é mudar a ORDEM das tags)

        # ── MODO RESIZE (modal) ────────────────────────────────────
        # SUPER+Alt+R entra no modo; setas redimensionam a janela;
        # Esc/Return volta ao modo default. Ver keymode abaixo.
        "SUPER+ALT,R,setkeymode,resize"
      ];

      axisbind = [
        "SUPER,DOWN,focusdir,right"
        "SUPER,UP,focusdir,left"
        "SUPER,RIGHT,focusdir,right"
        "SUPER,LEFT,focusdir,left"
        "SUPER+CTRL,DOWN,viewtoright"
        "SUPER+CTRL,UP,viewtoleft"
        "SUPER+CTRL,RIGHT,exchange_client,right"
        "SUPER+CTRL,LEFT,exchange_client,left"
      ];

      # ── MODO RESIZE (submapa) ────────────────────────────────────
      # Dispara com SUPER+Alt+R. Só as setas agem nesse modo; o resto
      # dos atalhos fica suspenso até Esc/Return voltar pro default.
      keymode = {
        resize = {
          bind = [
            "NONE,Left,resizewin,-20,0"
            "NONE,Right,resizewin,+20,0"
            "NONE,Up,resizewin,0,-20"
            "NONE,Down,resizewin,0,+20"
            "NONE,Escape,setkeymode,default"
            "NONE,Return,setkeymode,default"
          ];
        };
      };

      # ── MOUSE ────────────────────────────────────────────────────
      # SUPER + botão esquerdo arrasta a janela flutuante; SUPER + botão
      # direito redimensiona. (Espera-se btn_left/btn_right como nomes.)
      mousebind = [
        "SUPER,btn_left,moveresize,curmove"
        "SUPER,btn_right,moveresize,curresize"
      ];

      windowrule = [
        "isfloating:1,appid:.*[Bb]lueman.*"
        "isfloating:1,appid:pavucontrol"
        "isfloating:1,appid:copyq"
        "isfloating:1,title:^Picture-in-Picture$"
        "isfloating:1,appid:firefox$,title:^Picture-in-Picture$"
        "noblur:1,appid:slurp" # ferramenta de seleção de área — blur atrapalha ver o que tá selecionando
      ];
      # opacity global (niri: window-rule { opacity 0.96; }) e
      # "draw-border-with-background false" não têm chave global clara na
      # doc do mango — dava pra fazer via windowrule por app, mas preferi
      # não inventar um valor. Ajusta depois se fizer falta visualmente.
    };
  };

  # ── BLUETOOTH APPLET ─────────────────────────────────────────────────────
  systemd.user.services.mango-blueman-applet = {
    Unit = {
      Description = "Blueman applet (mango)";
      After       = [ "graphical-session.target" ];
      PartOf      = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart  = "${pkgs.blueman}/bin/blueman-applet";
      Restart    = "on-failure";
      RestartSec = "3s";
    };
  };

  # ── OVERRIDES ──────────────────────────────────────────────────────────────
  # Drop-ins (só sobrescrevem a diretiva indicada, preservam o resto do
  # unit original) — ver comentário original em niri.nix sobre por que
  # `systemd.user.services.<nome> = {...}` do Home Manager não serve aqui.
  #
  # PORTADO: NIRI_SOCKET → WAYLAND_DISPLAY (checagem mais genérica de
  # "sessão Wayland ativa", já que o mango não define uma env var própria
  # equivalente exposta globalmente do mesmo jeito).
  xdg.configFile."systemd/user/picom.service.d/override.conf".text = ''
    [Unit]
    ConditionEnvironment=!WAYLAND_DISPLAY
  '';
  xdg.configFile."systemd/user/app-picom@autostart.service.d/override.conf".text = ''
    [Unit]
    ConditionEnvironment=!WAYLAND_DISPLAY
  '';
  xdg.configFile."systemd/user/dunst.service.d/override.conf".text = ''
    [Unit]
    Conflicts=mango-session.target
  '';
}
