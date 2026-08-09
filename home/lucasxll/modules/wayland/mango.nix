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

    # ── AUTOSTART (via autostart_sh, NÃO exec-once) ─────────────────────
    # O módulo Home Manager do mango só roda a ativação do systemd user
    # session (dbus-update-activation-environment + `systemctl --user start
    # mango-session.target`, que pula pro graphical-session.target) DENTRO do
    # autostart.sh gerado por esta opção. Se a gente puser os comandos em
    # `settings.exec-once`, o autostart.sh nunca é criado → o target nunca
    # sobe → o noctalia-shell.service (WantedBy=graphical-session.target)
    # nunca inicia → a barra não aparece. Foi exatamente isso que aconteceu.
    # Corrigido movendo os comandos pra cá.
    autostart_sh = ''
      pkill mpris-proxy; mpris-proxy &
      sleep 2 && sudo systemctl restart mouse-invert
      sleep 5 && nm-applet --indicator &
      sleep 5 && systemctl --user start mango-blueman-applet
      # Sem sessão Plasma, não há kded rodando pra manter o ksycoca em dia —
      # sem isso, "Abrir com" no Dolphin fica sem listar nenhum app instalado.
      sleep 2 && kbuildsycoca6 --noincremental
    '';

    settings = {
      # ── INPUT ────────────────────────────────────────────────────────
      xkb_rules_layout          = "us"; # ver nota original: firmware QMK espera posições US
      repeat_delay               = 400;
      repeat_rate                 = 30;
      mouse_natural_scrolling      = 1;
      trackpad_natural_scrolling    = 1;
      tap_to_click                   = 1;
      disable_while_typing            = 1;

      # ── VISUAL — Nord, combinando com o Stylix/Noctalia ──────────────
      # Gaps externas (gappoh/gappov) grandes: quando apertar SUPER+F
      # (togglemaximizescreen) a janela maximizada usa essas gaps como margem
      # → fica "encolhida", menor que a tela (estética estilo niri), junto com
      # a animação MOVE (animation_duration_move=500) que faz crescer/encolher
      # suavemente. Pedido do usuário.
      gappih = 6; gappiv = 6; gappoh = 26; gappov = 26;
      borderpx    = 1; # borda fina — pedido: "bordas das janelas mais pequenas"
      rootcolor   = "0x2e3440ff"; # fundo do root, base00 do Nord
      bordercolor = "0x4c566aff"; # inativa (nord3)
      focuscolor  = "0x81a1c1ff"; # ativa (nord8 azul)
      urgentcolor = "0xbf616aff"; # vermelho (nord11)
      maximizescreencolor = "0xa3be8cff"; # verde (nord14)
      scratchpadcolor      = "0xb48eadff"; # roxo (nord15)

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

      # ── ANIMAÇÕES ────────────────────────────────────────────────────
      # Portado do mango-fedora (theblackdon): zoom suave em vez de fade.
      # Curvas ease-out-quint (0.46,1.0,0.29,1) deixam o movimento "gostoso
      # de mexer"; close é mais rápido pra não atrasar a troca de janela.
      animations             = 1;
      layer_animations       = 1;
      animation_type_open    = "zoom";
      animation_type_close   = "zoom";
      animation_fade_in      = 1;
      animation_fade_out     = 1;
      tag_animation_direction = 0; # vertical, como os tags 1-9
      zoom_initial_ratio     = 0.4;
      zoom_end_ratio         = 0.8;
      animation_duration_move  = 500;
      animation_duration_open  = 400;
      animation_duration_tag   = 350;
      animation_duration_close = 250;
      animation_duration_focus = 0;
      animation_curve_move  = "0.46,1.0,0.29,1";
      animation_curve_open  = "0.46,1.0,0.29,1";
      animation_curve_tag   = "0.46,1.0,0.29,1";
      animation_curve_close = "0.08,0.92,0,1";
      animation_curve_focus = "0.46,1.0,0.29,1";

      cursor_theme = "Bibata-Modern-Classic";
      cursor_size  = 24;

      # ── LAYOUT — scroll tiling estilo niri ───────────────────────────────
      # TODAS as 9 tags usam `scroller` (colunas roláveis, como o niri) — assim
      # o scroll tiling fica ativo desde o boot, em qualquer tag. Pedido do
      # usuário: "deixa o mango tiling automático sempre que eu abrir o
      # computador, experiência próxima do niri".
      # Navegação: SUPER+ALT+setas (scroller_stack) e SUPER+ALT+E (expandir).
      tagrule = [
        "id:1,layout_name:scroller"
        "id:2,layout_name:scroller"
        "id:3,layout_name:scroller"
        "id:4,layout_name:scroller"
        "id:5,layout_name:scroller"
        "id:6,layout_name:scroller"
        "id:7,layout_name:scroller"
        "id:8,layout_name:scroller"
        "id:9,layout_name:scroller"
      ];

      scroller_structs             = 20;
      # Proporção da janela FOCADA (master) em LARGURA: 0.97 = quase a tela
      # toda, só uma fatia fina da janela ao lado aparece (confortável
      # visualmente — usuário pediu 0.97).
      scroller_default_proportion  = 0.97;
      scroller_focus_center        = 1;   # foca a coluna central (como niri)
      scroller_prefer_center       = 0;
      scroller_proportion_preset   = "0.5,0.8,1.0";
      scroller_default_proportion_single = 1.0;
      # Transição automática entre janelas/colunas ao levar o cursor à borda.
      # `allow_speed` = gatilho: troca quando o cursor cruza a borda com
      # velocidade ≥5 (bem fácil de disparar). Usuário testando 5.
      edge_scroller_pointer_focus  = 1;
      edge_scroller_focus_allow_speed = 5.0;

      # ── ENV ──────────────────────────────────────────────────────────
      env = [
        "PATH,/run/wrappers/bin:/run/current-system/sw/bin:/etc/profiles/per-user/lucasxll/bin:/nix/var/nix/profiles/default/bin:/usr/local/bin:/usr/bin:/bin"
        "QT_QPA_PLATFORM,wayland"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "_JAVA_AWT_WM_NONREPARENTING,1"
      ];

      # ── ATALHOS ──────────────────────────────────────────────────────
      bind = [
        "SUPER,Return,spawn,wezterm"
        "SUPER,T,spawn,wezterm"
        "SUPER+SHIFT,Return,spawn,wezterm"

        "SUPER,D,spawn,noctalia-shell ipc call launcher toggle"
        "SUPER,R,spawn,noctalia-shell ipc call launcher toggle"
        "SUPER,Space,spawn,noctalia-shell ipc call launcher toggle"

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
        # mpvpaper (wallpaper animado) — SUPER+CTRL+B (tecla home row; era
        # SUPER+Semicolon, que no Corne v4 vive na camada SYM, difícil)
        "SUPER+CTRL+B,spawn_shell,pkill mpvpaper || mpvpaper -o 'no-audio loop' '*' ~/Pictures/wallpapers/wallpaper.mp4"

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

        # ── Ajustes de janela — SUPER+CTRL (polegar, confortável no Corne v4)
        # setmfact: H/L na home row direita (era SUPER+ALT+H/L, ALT difícil)
        "SUPER+CTRL,H,setmfact,-0.05"
        "SUPER+CTRL,L,setmfact,+0.05"

        "SUPER,C,centerwin"
        "SUPER,Tab,focuslast"
        "SUPER,G,toggleglobal"
        # Scratchpad — SUPER+CTRL+Space (polegar, era SUPER+ALT+S)
        "SUPER+CTRL,Space,toggle_scratchpad"
        # SUPER+O (toggleoverview) REMOVIDO: o mango-nightly crasha ao abrir o
        # overview (overview_layout_card → wlr_scene_buffer set_source_box →
        # abort) — derrubava a sessão gráfica. O hot corner também foi
        # desativado por isso.

        "SUPER,U,viewtoright"
        "SUPER,I,viewtoleft"
        # tagtoright/toleft já via SUPER+CTRL+SHIFT+J/K acima

        # ── SCROLLER (scroll tiling estilo niri) ──────────────────────
        # Navegação de colunas: SUPER+CTRL+U/I/O/P (home row esquerda +
        # direita, confortável) — era SUPER+ALT+setas (setas na camada SYM).
        "SUPER+CTRL,U,scroller_stack,left"
        "SUPER+CTRL,I,scroller_stack,right"
        "SUPER+CTRL,O,scroller_stack,up"
        "SUPER+CTRL,P,scroller_stack,down"
        "SUPER+CTRL,E,set_proportion,1.0"
        "SUPER+CTRL,Q,set_proportion,0.5"

        # ── MODO RESIZE (modal) ────────────────────────────────────
        # SUPER+CTRL+SHIFT+R entra no modo (era SUPER+ALT+R, ALT difícil);
        # setas redimensionam; Esc/Return volta. Ver keymode abaixo.
        "SUPER+CTRL+SHIFT,R,setkeymode,resize"
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
}
