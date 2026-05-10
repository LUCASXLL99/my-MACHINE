# hosts/nixos/default.nix
# Configuração do sistema — apenas o que precisa de root

{ config, pkgs, inputs, ... }:

{
  imports = [
    ../../modules/nixos/hardware/sddm-reflect.nix
    ./hardware-configuration.nix
    ../../modules/nixos/hardware/input-left-handed.nix
    ../../modules/nixos/hardware/bluetooth-audio.nix   # ← ADICIONADO (estava esquecido)
    ../../modules/nixos/hardware/kanata-keyboard
    ../../modules/nixos/software/no-keyring.nix
    ../../modules/nixos/software/yazi-deps.nix
    ../../modules/nixos/software/niri.nix
    ../../modules/nixos/software/rust-dev.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.stylix.nixosModules.stylix               # ← STYLIX
  ];

  # ── STYLIX — theming base16 unificado ────────────────────────
  #
  # Paleta escolhida: Tokyo Night Dark
  # Motivo: já era o tema dominante em toda a config (waybar, mako, kitty,
  # wezterm, dunst, fuzzel) — Nord só aparecia no Dolphin/KDE via kvantum.
  # Unificar em Tokyo Night elimina a tensão entre os dois temas.
  #
  # Wallpaper: Stylix precisa de uma imagem para derivar a paleta quando
  # o mode é "auto". Como usamos paleta fixa (base16Scheme inline) e o
  # wallpaper é gerenciado pelo swww/feh, passamos um pixel de cor sólida.
  # Para usar uma imagem real: stylix.image = /home/lucasxll/Pictures/wallpapers/wp.jpg;
  stylix.base16Scheme = {
    # ── Tokyo Night Dark ────────────────────────────────────────
    scheme      = "Tokyo Night Dark";
    author      = "lucasxll (adaptado de enkia/tokyo-night-vscode-theme)";
    base00      = "1a1b26"; # bg            — fundo principal
    base01      = "16161e"; # bg_dark        — fundo mais escuro
    base02      = "292e42"; # bg_highlight   — seleção / hover
    base03      = "565f89"; # comment        — comentários, invisíveis
    base04      = "9aa5ce"; # dark5          — fg escuro
    base05      = "c0caf5"; # fg             — texto principal
    base06      = "cfc9c2"; # fg_dark        — fg claro secundário
    base07      = "d5d6db"; # white          — quase branco
    base08      = "f7768e"; # red            — erros, diff deletado
    base09      = "ff9e64"; # orange         — números, constantes
    base0A      = "e0af68"; # yellow         — warnings, classes
    base0B      = "9ece6a"; # green          — strings, diff inserido
    base0C      = "73daca"; # teal           — suporte, regex
    base0D      = "7aa2f7"; # blue           — funções, atributos
    base0E      = "bb9af7"; # purple         — keywords
    base0F      = "db4b4b"; # dark_red       — deprecated
  };

  # Pixel sólido como wallpaper para o Stylix (não conflita com swww/feh)
  stylix.image = config.lib.stylix.pixel "1a1b26";

  stylix.fonts = {
    monospace = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name    = "JetBrainsMono Nerd Font";
    };
    sansSerif = {
      package = pkgs.inter;
      name    = "Inter";
    };
    serif = {
      package = pkgs.inter;
      name    = "Inter";
    };
    sizes = {
      terminal    = 13;
      applications = 11;
      desktop     = 11;
    };
  };

  home-manager = {
    useGlobalPkgs    = true;
    useUserPackages  = true;
    extraSpecialArgs = { inherit inputs; };
    backupFileExtension = "backup";
    # O stylix release-25.05 novo não injeta mais o módulo HM automaticamente
    # via nixosModules — é preciso declarar explicitamente aqui para que as
    # opções `stylix.*` existam dentro de home-manager.users.lucasxll.
    sharedModules = [ inputs.stylix.homeModules.stylix ];
    users.lucasxll = import ../../home/lucasxll/default.nix;
  };

  # ── BOOT ─────────────────────────────────────────────────────
  boot = {
    kernelPackages = pkgs.linuxPackages_6_1;
    loader = {
      systemd-boot.enable      = true;
      efi.canTouchEfiVariables = true;
    };
    kernelModules = [ "kvm-amd" "kvm-intel" "usbcore" "usbhid" "uinput" ];
    extraModprobeConfig = "options usbcore autosuspend=2";
  };

  # ── REDE ─────────────────────────────────────────────────────
  networking = {
    hostName              = "nixos";
    networkmanager.enable = true;
  };

  # ── LOCALIZAÇÃO ──────────────────────────────────────────────
  time.timeZone      = "America/Belem";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8"; LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8"; LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8"; LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8"; LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };
  console.keyMap = "br-abnt2";

  # ── HARDWARE ─────────────────────────────────────────────────
  hardware.bluetooth.enable    = true;
  hardware.keyboard.qmk.enable = true;
  services.pulseaudio.enable = false;

  # ── DISPLAY ──────────────────────────────────────────────────
  services.xserver = {
    enable      = true;
    xkb.layout  = "br";
    xkb.variant = "nodeadkeys";
    windowManager.bspwm.enable = true;
  };
  services.displayManager.sddm = {
    enable = true;
    settings = {
      General = {
        # Não lembra o último usuário/sessão — evita tentar iniciar niri
        # automaticamente quando já há uma sessão ativa no logind
        RememberLastUser    = false;
        RememberLastSession = false;
      };
      # Garante que o SDDM não tente iniciar sessão duplicada quando
      # o usuário já tem uma sessão ativa em outro TTY
      Users.RememberLastUser = false;
    };
  };

  # ── ÁUDIO ────────────────────────────────────────────────────
  security.rtkit.enable = true;

  # ── Hyprlock precisa de entrada PAM para autenticar ──────────────
  # Sem isso o hyprlock aceita a senha visualmente mas não consegue
  # destravar a sessão — o sistema congela e só sai via TTY+kill.
  security.pam.services.hyprlock  = {};
  security.pam.services.noctalia  = {};  # lockscreen noctalia usa PAM
  services.upower.enable = true;         # bateria no noctalia Control Center

  # ── Logind: matar processos ao sair da sessão ────────────────────
  # Sem killUserProcesses, ao trocar de TTY ou encerrar uma sessão
  # niri, os serviços systemd --user (xwayland-satellite, mouse-invert,
  # waybar…) continuam rodando na sessão "morta". Isso causa:
  #   • Sessão niri "ativa" que bloqueia novo login
  #   • Mouse invertido persistindo no bspwm
  #   • Conflito de DISPLAY entre sessões
  services.logind = {
    killUserProcesses = true;
    # Fecha a sessão corretamente ao fechar a tampa ou desligar o monitor
    lidSwitch       = "suspend";
    lidSwitchDocked = "ignore";
    # Reduz o delay de liberação de sessão — sem isso o logind espera até
    # 5s para fechar a sessão anterior, o SDDM fica bloqueado e o login
    # aparentemente "trava" ao tentar entrar logo após sair do niri.
    extraConfig = ''
      InhibitDelayMaxSec=2
      HandlePowerKey=suspend
    '';
  };

  # Limita a 2 sessões simultâneas por usuário (1 gráfica + 1 manager).
  # O log mostrou sessions 6 (tty3) e 9 (tty4) rodando ao mesmo tempo —
  # dois compositors em paralelo causam conflito de WAYLAND_DISPLAY e
  # congelamento ao trocar TTY. Com maxlogins=2, o logind rejeita um
  # terceiro login antes de matar a sessão anterior.
  security.pam.loginLimits = [{
    domain = "*";
    type   = "hard";
    item   = "maxlogins";
    value  = "4";
  }];
  services.pipewire = {
    enable = true; alsa.enable = true;
    alsa.support32Bit = true; pulse.enable = true;
  };

  # ── IMPRESSÃO ────────────────────────────────────────────────
  services.printing.enable = true;

  # ── DISPOSITIVOS REMOVÍVEIS ───────────────────────────────────
  # udisks2: daemon que detecta e monta pen drives, HDs externos,
  # teclados e qualquer dispositivo USB removível automaticamente.
  # Sem ele, o Dolphin não consegue ver nem montar nada que plugar.
  services.udisks2.enable = true;

  # gvfs: camada de abstração de arquivos para apps GTK/KDE.
  # Necessário para o Dolphin mostrar o dispositivo na barra lateral
  # e para operações de copiar/mover funcionar com o file picker.
  services.gvfs.enable = true;

  # ── MOUSE HOTPLUG ─────────────────────────────────────────────
  # Reinicia o serviço mouse-invert-y quando qualquer mouse novo é
  # plugado. Sem isso, mouses plugados após o login não são capturados
  # porque o script Python faz find_mice() apenas na inicialização.
  services.udev.extraRules = ''
    SUBSYSTEM=="input", ACTION=="add", ENV{ID_INPUT_MOUSE}=="1", \
      TAG+="systemd", ENV{SYSTEMD_USER_WANTS}="mouse-invert-y.service"
  '';

  # ── ENERGIA ──────────────────────────────────────────────────
  services.power-profiles-daemon.enable = false;
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = { governor = "powersave"; turbo = "never"; };
      # Na tomada: permite turbo automático (melhor performance sem custo de bateria)
      charger = { governor = "performance"; turbo = "auto"; };
    };
  };

  # ── VIRTUALIZAÇÃO ────────────────────────────────────────────
  virtualisation.docker.enable = true;

  # ── VARIÁVEIS DE AMBIENTE ──────────────────────────────────
  environment.sessionVariables = {
    ELECTRON_PASSWORD_STORE = "basic";

    # ── Qt: NÃO forçar QT_QPA_PLATFORM globalmente ───────────────────
    # Cada sessão tem necessidades diferentes:
    #   - Niri (Wayland) → seta QT_QPA_PLATFORM=wayland no environment{} do KDL
    #   - bspwm (X11)    → Qt detecta X11 sozinho, usa xcb por padrão
    # Forçar "xcb" aqui quebra o Dolphin e apps Qt no Niri (precisariam de
    # DISPLAY que pode não estar disponível). Forçar "wayland" quebra Qt no bspwm.
    #
    # QT_PLUGIN_PATH e QT_QPA_PLATFORM_PLUGIN_PATH foram removidos:
    # apontavam para Qt5 hardcoded, mas Dolphin e apps KDE modernos no nixpkgs
    # são Qt6 — esses paths são completamente ignorados pelo Qt6 e confundem
    # o Qt5. O nixpkgs já injeta os paths corretos via wrappers dos pacotes.

    # ── Android Studio / AWT ─────────────────────────────────────────
    _JAVA_AWT_WM_NONREPARENTING = "1";

    # ── Rust / Cargo ─────────────────────────────────────────────────
    # ── Rust / Cargo ─────────────────────────────────────────────────
    OPENSSL_DIR = "${pkgs.openssl.dev}";
    OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
    PATH = "$HOME/.cargo/bin:$PATH";

    # ── WebAssembly / WASM ────────────────────────────────────────────
    # Diz ao Cargo para usar lld como linker ao compilar para wasm32.
    # O GNU ld padrão do nixpkgs não suporta o target wasm32 — sem isso
    # o `cargo build --target wasm32-unknown-unknown` falha com linker error.
    CARGO_TARGET_WASM32_UNKNOWN_UNKNOWN_LINKER = "${pkgs.llvmPackages.lld}/bin/lld";

    # ARMADILHA 1 (CORRIGIDA): mold não aceita -m64 que build scripts
    # (proc-macros, build.rs) passam ao compilar targets nativos durante
    # wasm-pack. lld é compatível tanto com wasm-pack quanto com compilação
    # nativa x86_64 — sem regressão de velocidade relevante.
    CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER = "${pkgs.llvmPackages.lld}/bin/lld";

    # wasm-opt é chamado pelo wasm-pack após compilar para otimizar o .wasm.
    # Sem este PATH explícito, wasm-pack pode não encontrar o binário do
    # binaryen quando chamado fora de um shell com PATH completo (ex: pelo niri).
    WASM_OPT = "${pkgs.binaryen}/bin/wasm-opt";

    # ARMADILHA 5 (CORRIGIDA): sessionVariables só carregam em sessões NOVAS
    # após rebuild. Se a variável não aparecer no terminal: abra um novo
    # terminal ou rode: source /etc/set-environment
    RUST_LOG       = "debug";
    RUST_BACKTRACE = "1";
  };

  # ── SERVIÇOS ─────────────────────────────────────────────────
  services.dbus.enable           = true;
  services.spice-vdagentd.enable = true;

  # ── XDG PORTALS ──────────────────────────────────────────────
  # Sem xdg.portal.config, o xdg-desktop-portal não sabe qual backend
  # usar para cada interface — file picker, screen share, etc.
  # Resultado: Dolphin não abre dialog de arquivo, apps não conseguem
  # compartilhar tela, e alguns apps travam esperando resposta do portal.
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    # Mapeia cada interface ao portal correto para sessões niri/wlroots
    config = {
      common = {
        # Fallback para qualquer interface não mapeada explicitamente
        default = [ "gtk" ];
      };
      niri = {
        default                      = [ "gtk" ];
        # Screen cast e remote desktop via wlr (compatível com niri/wlroots)
        "org.freedesktop.impl.portal.ScreenCast"    = [ "wlr" ];
        "org.freedesktop.impl.portal.RemoteDesktop" = [ "wlr" ];
        # File chooser e settings via GTK (mais estável fora do KDE/GNOME)
        "org.freedesktop.impl.portal.FileChooser"   = [ "gtk" ];
        "org.freedesktop.impl.portal.Settings"      = [ "gtk" ];
      };
    };
  };

  # ── PROGRAMAS ────────────────────────────────────────────────
  programs = {
    firefox.enable = false;
    # Instala as regras udev do Android — necessário para ADB funcionar
    # sem sudo. Sem isso, o kernel não dá permissão ao dispositivo mesmo
    # com o usuário no grupo plugdev.
    adb.enable = true;
    nix-ld = {
      enable    = true;
      # Bibliotecas necessárias para binários ELF dinâmicos não-nix:
      # as 2 linhas originais cobrem compiladores; as demais são necessárias
      # para o Android Studio, o emulador Android e componentes nativos do SDK.
      libraries = with pkgs; [
        stdenv.cc.cc glibc
        zlib
        freetype fontconfig
        libGL libGLU
        libxkbcommon
        xorg.libX11 xorg.libXext xorg.libXrender
        xorg.libXtst xorg.libXi xorg.libXfixes
        # ── Rust: libs nativas para crates C-heavy ───────────────────
        # Necessárias para ferramentas externas (binários ELF não-nix)
        # que linkam dinamicamente contra essas libs em runtime.
        openssl          # ring, rustls, reqwest com TLS nativo
        postgresql.lib   # sqlx/diesel com feature postgres
        sqlite           # rusqlite, sqlx com feature sqlite
        libclang.lib     # bindgen em ferramentas externas
      ];
    };
    # NOTA: programas.zsh.enable = true é necessário para que zsh apareça em
    # /etc/shells e possa ser shell de login. NÃO configure oh-my-zsh aqui —
    # isso duplica com o Home Manager e gera conflito no /etc/zshrc.
    # Todo o restante da config zsh fica em home/lucasxll/modules/zsh.nix.
    zsh.enable = true;
  };

  # ── FONTES ───────────────────────────────────────────────────
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    inter
  ];

  # ── USUÁRIOS ─────────────────────────────────────────────────
  users.groups.yurii = {};
  users.users = {
    yurii = {
      isNormalUser       = true;
      group              = "yurii";
      hashedPasswordFile = "/etc/passwdfile";
      shell              = pkgs.zsh;
    };
    lucasxll = {
      isNormalUser   = true;
      description    = "LUCASXLL";
      shell          = pkgs.zsh;
      extraGroups    = [
        "networkmanager" "wheel" "docker"
        "libvirt" "libvirtd" "kvm" "qemu-libvirtd"
        "adbusers" "uucp" "uinput" "input" "plugdev"
        "usb" "disk" "cdrom"
      ];
      hashedPassword = "$6$6PEfHzY1BpSqVGXG$j1j7Chn4nt3ehnojWM2mZMaof2LhA2MTN48MNGFzlqZPHjxbgMatRWNU34D6yC5aoeGk1pVc9aTQzc07Px.s8.";
      packages = [];
    };
  };

  security.sudo.extraRules = [
    {
      users = [ "lucasxll" ];
      commands = [
        { command = "ALL"; options = [ "NOPASSWD" ]; }
      ];
    }
  ];

  # ── PACOTES DO SISTEMA ───────────────────────────────────────
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim git wget htop fastfetch
    zip unzip
    # ── Ferramentas Wayland / XWayland produtividade ─────────────────
    # Screenshot
    grim          # captura de tela wayland nativa
    slurp         # seleção de área (usa junto com grim)
    swappy        # edição/anotação rápida de screenshot

    # Clipboard
    wl-clipboard  # wl-copy / wl-paste — equivalente ao xclip no Wayland
    cliphist      # histórico de clipboard com integração fuzzel/wofi

    # Utilitários de janela / tela
    wl-mirror     # espelha um output wayland em outro (útil para apresentações)
    wlr-randr     # controle de outputs wayland (equivalente ao xrandr)

    # Media / áudio
    playerctl     # controle de media players via MPRIS (play/pause/next)
    pavucontrol   # mixer de áudio gráfico

    # Outros
    xdg-utils     # xdg-open, xdg-mime — abre arquivos com o app certo
    libnotify     # notify-send — notificações da linha de comando
    wezterm

    vivaldi obsidian onlyoffice-bin_latest gnome-disk-utility
    rofi
    kdePackages.dolphin kdePackages.ark
    # ── Android Studio via XWayland-Satellite ────────────────────────
    # O Android Studio usa Java AWT — uma tecnologia X11 pura que não
    # fala Wayland. No Niri (compositor Wayland), ele precisa do
    # xwayland-satellite para ter um servidor X onde renderizar.
    #
    # O wrapper abaixo garante que:
    #   1. DISPLAY=:0 aponta para o socket do xwayland-satellite
    #   2. _JAVA_AWT_WM_NONREPARENTING evita janelas invisíveis em
    #      compositors que não fazem reparenting (como o Niri)
    #
    # Sem esse wrapper, abrir o Studio de qualquer launcher (fuzzel,
    # terminal, .desktop) poderia herdar um DISPLAY vazio ou errado.
    (pkgs.symlinkJoin {
      name = "android-studio";
      paths = [ pkgs.android-studio ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/android-studio \
          --set DISPLAY ":1" \
          --set _JAVA_AWT_WM_NONREPARENTING "1"

        # O .desktop gerado pelo nixpkgs contém o caminho absoluto do store
        # original (ex: Exec=/nix/store/xxxx-android-studio/bin/android-studio).
        # Quando um launcher (rofi, noctalia) lê esse .desktop e executa o Exec=,
        # ele chama o binário ORIGINAL — sem DISPLAY=:0, sem _JAVA_AWT_WM_NONREPARENTING.
        # O wrapProgram acima só envolve $out/bin/android-studio, então o .desktop
        # precisa ser corrigido para apontar para esse wrapper.
        # $out/share/applications/ é um symlink de diretório apontando para o
        # store original (somente leitura). Qualquer tentativa de criar/editar
        # arquivos dentro dele falha com Permission denied.
        # Fix: recriar o diretório como real e copiar os .desktop já processados.
        apps="$out/share/applications"
        if [ -L "$apps" ]; then
          orig=$(readlink -f "$apps")
          rm "$apps"
          mkdir -p "$apps"
          for f in "$orig"/*.desktop; do
            sed "s|Exec=.*/bin/android-studio|Exec=$out/bin/android-studio|g" \
              "$f" > "$apps/$(basename "$f")"
          done
        fi
      '';
    })

    python3 python312Packages.pip

    # ── Rust core ────────────────────────────────────────────────────
    # rustup gerencia toolchains (stable, nightly) e targets.
    # Após o rebuild, rode:
    #   rustup default stable
    #   rustup target add wasm32-unknown-unknown
    rustup

    # ── WebAssembly — toolchain completo ─────────────────────────────
    #
    # wasm-pack  → compila o crate Rust para .wasm + gera bindings JS
    #              uso: wasm-pack build --target web --out-dir pkg
    # trunk      → dev-server com HMR para projetos Rust/WASM (alt. ao wasm-pack)
    #              uso: trunk serve  (lê index.html com <link data-trunk ...>)
    wasm-pack
    trunk

    # wasm-bindgen-cli — CLI autônoma do wasm-bindgen.
    # Necessária quando se usa wasm-bindgen diretamente (sem wasm-pack)
    # ou para inspecionar/re-gerar bindings manualmente.
    # IMPORTANTE: a versão aqui deve coincidir com a do Cargo.toml.
    wasm-bindgen-cli

    # binaryen — fornece o `wasm-opt`, usado pelo wasm-pack na fase de
    # otimização do binário .wasm (-O3, --strip-debug, etc.).
    # Sem ele, wasm-pack emite aviso e pula a otimização.
    binaryen

    # wabt (WebAssembly Binary Toolkit) — ferramentas de inspeção/debug:
    #   wasm2wat       → converte .wasm binário em WAT (texto legível)
    #   wat2wasm       → compila WAT de volta para .wasm
    #   wasm-validate  → valida um .wasm sem executar
    #   wasm-objdump   → inspeciona seções, imports, exports do .wasm
    wabt

    # ── Node.js — ecosistema JS auxiliar ─────────────────────────────
    # Necessário para:
    #   npx serve .          → servidor estático local para testar o .wasm
    #   npx http-server .    → alternativa ao python3 -m http.server
    #   npm install          → projetos que misturam WASM + bundler (Vite, Webpack)
    nodejs_22

    # ── Cargo utilitários de desenvolvimento ─────────────────────────
    # cargo-watch  → monitora arquivos e recompila automaticamente.
    #                uso: cargo watch -s "wasm-pack build --target web"
    cargo-watch

    # cargo-generate → cria projetos a partir de templates Git.
    #                  uso: cargo generate rustwasm/wasm-pack-template
    cargo-generate

    # cargo-edit → manipula dependências via CLI (sem editar Cargo.toml manualmente).
    #              uso: cargo add wasm-bindgen
    #                   cargo upgrade
    cargo-edit

    # cargo-nextest → substituto do `cargo test`: mais rápido, output legível,
    #                 suporte a filtros e retries.
    #                 uso: cargo nextest run
    cargo-nextest

    # cargo-audit → verifica vulnerabilidades conhecidas (CVEs) nas dependências.
    #               uso: cargo audit
    #               Rode antes de publicar qualquer serviço.
    cargo-audit

    # cargo-expand → expande macros proc-macro para inspecionar o código gerado.
    #                Indispensável para debugar derive macros e wasm-bindgen.
    #                uso: cargo expand
    cargo-expand

    # cargo-flamegraph → profiling visual: gera flamegraph.svg do binário.
    #                    uso: cargo flamegraph --bin meu-binario
    cargo-flamegraph

    # ── Linker / compilação nativa ────────────────────────────────────
    # lld (LLVM linker) — linker padrão para targets WASM no Rust.
    # Muito mais rápido que o GNU ld para wasm32-unknown-unknown.
    # O Cargo o detecta automaticamente quando está no PATH.
    llvmPackages.lld

    # mold — linker ultrarrápido para binários nativos Linux.
    # Não substitui o lld para WASM, mas acelera muito a compilação
    # de crates nativos (proc-macros, build-scripts) que rodam no host.
    mold

    pkg-config
    openssl
    openssl.dev


    gcc stdenv.cc.cc
    zulu8 openjdk11 jdk17 jdk21

    docker qemu qemu_kvm virt-manager libvirt acl polkit
    spice spice-gtk spice-protocol libguestfs libusb1 usbutils

    qmk qmk-udev-rules qmk_hid via vial kanata-with-cmd
    sxhkd brightnessctl

    auto-cpufreq libnotify
    xwinwrap mpv yt-dlp

    # ── Qt Wayland e integração KDE ──────────────────────────────────
    # Qt5: qtwayland permite que apps Qt5 (legacy) usem o backend Wayland.
    # Mantido porque alguns apps ainda são Qt5.
    libsForQt5.qt5.qtwayland

    # Qt6: suporte Wayland para apps Qt6 modernos (Dolphin, etc.)
    # O nixpkgs gerencia automaticamente, mas declarar explicitamente
    # garante que o backend está disponível no Niri.
    kdePackages.qtwayland

    # plasma-integration: fornece o plugin QT_QPA_PLATFORMTHEME=kde para Qt5 e Qt6.
    # Sem ele, qualquer app que tente usar o tema "kde" crasha silenciosamente.
    # O Dolphin, mesmo sem Plasma rodando, usa este plugin para integração visual.
    libsForQt5.plasma-integration
    kdePackages.plasma-integration

    xdg-desktop-portal-gtk

    # ── Debugger ────────────────────────────────────────────────────
    lldb              # debugger LLVM — base para codelldb / testes nativos

    # ── LSP servers web ─────────────────────────────────────────────
    nodePackages.typescript-language-server   # JS + TS
    nodePackages.vscode-langservers-extracted # HTML + CSS + JSON + ESLint LSP
    nodePackages."@tailwindcss/language-server"  # Tailwind CSS
    emmet-language-server                     # emmet para HTML/CSS
    nodePackages.prettier                     # formatador web
    nodePackages.eslint                       # linter JS/TS

    # ── Rust LSP ────────────────────────────────────────────────────
    rust-analyzer   # LSP Rust declarativo (não depende do rustup ativo)
    rustfmt         # formatador Rust

    # ── Terminal utilities para web dev ─────────────────────────────
    lazygit   # TUI git — muito mais ergonômico que git CLI direto
    httpie    # cliente HTTP legível
    websocat  # testa WebSockets via terminal
    jq        # processa JSON no terminal
    yq-go     # processa YAML/TOML no terminal (yq-go é o pacote nixpkgs)
    curlie    # curl com interface do httpie
    # ── Deploy / backend ─────────────────────────────────────────────
    # flyctl → CLI do Fly.io: deploy de serviços Rust com um comando.
    #          uso: fly deploy  /  fly logs  /  fly ssh console
    flyctl

    # caddy → servidor HTTP/HTTPS com TLS automático (Let's Encrypt).
    #         Melhor que nginx para dev local pois gera cert autoassinado
    #         sem configuração. Útil para testar CSP real via HTTPS.
    #         uso: caddy file-server --listen :8443
    caddy

    # sqlx-cli → migrações de banco de dados para projetos Rust com sqlx.
    #            uso: sqlx migrate run  /  sqlx migrate add nome
    sqlx-cli

    # mkcert → gera certificados HTTPS locais confiáveis pelo browser.
    #          Par perfeito com caddy para testar HTTPS sem aviso de cert.
    #          uso: mkcert -install && mkcert localhost 127.0.0.1
    mkcert

    # ── Ferramentas de terminal ───────────────────────────────────────
    # btop → monitor de sistema visual (substitui htop).
    btop

    # dust → visualização de uso de disco por diretório (substitui du).
    #        uso: dust  /  dust ~/rustteste
    dust

    # ripgrep → busca ultrarrápida em arquivos (respeita .gitignore).
    #           uso: rg "pattern"
    ripgrep

    # fd → substituto ergonômico do `find`.
    #      uso: fd nome  /  fd -e rs (arquivos .rs)
    fd

    # tokei → conta linhas de código por linguagem no projeto.
    #         uso: tokei
    tokei

    # hyperfine → benchmarking de comandos shell com estatísticas.
    #             uso: hyperfine "wasm-pack build --target web"
    hyperfine

    # ── Docker / virtualização ────────────────────────────────────────
    # lazydocker → TUI para gerenciar containers, imagens e volumes Docker.
    #              uso: lazydocker
    lazydocker

    # dive → inspeciona camadas de imagens Docker para otimizar tamanho.
    #        uso: dive nome-da-imagem
    dive

    # ── Segurança / rede ─────────────────────────────────────────────
    # wireshark → análise de pacotes de rede. Essencial ao expor serviços.
    wireshark

    fx        # explorador de JSON interativo no terminal
  ];

  # ── KDE SERVICE MENUS ───────────────────────────────────────────
  # Garante que os service menus do Ark (compressão/extração no Dolphin)
  # fiquem linkados em /run/current-system/sw/share/kservices5/.
  # Sem isso, o Dolphin fora do Plasma não encontra os menus de contexto.
  environment.pathsToLink = [
    "/share/kservices5"
    "/share/kservices5/ServiceMenus"
    "/share/kio"
    "/share/kio/servicemenus"
  ];

  # ── NIX ──────────────────────────────────────────────────────
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store   = true;
  };
  nix.gc = {
    automatic = true;
    dates     = "weekly";
    options   = "--delete-older-than 14d";
  };

  # Workaround bug modules-shrunk NixOS 25.05
  nixpkgs.overlays = [
    (_: prev: {
      makeModulesClosure = x:
        prev.makeModulesClosure (x // { allowMissing = true; });
    })
  ];
  boot.initrd.includeDefaultModules = false;
  system.stateVersion = "25.05";
}
