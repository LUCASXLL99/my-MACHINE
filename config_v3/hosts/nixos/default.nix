# hosts/nixos/default.nix — configuração do sistema (requer root)

{ config, pkgs, inputs, ... }:

{
  imports = [
    ../../modules/nixos/hardware/sddm-reflect.nix
    ./hardware-configuration.nix
    ../../modules/nixos/hardware/input-left-handed.nix
    ../../modules/nixos/hardware/bluetooth-audio.nix
    ../../modules/nixos/hardware/kanata-keyboard
    ../../modules/nixos/software/no-keyring.nix
    ../../modules/nixos/software/yazi-deps.nix
    ../../modules/nixos/software/niri.nix
    ../../modules/nixos/software/rust-dev.nix
    ../../modules/nixos/software/wallcards.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.stylix.nixosModules.stylix
  ];

  # ── STYLIX — paleta Tokyo Night Dark ────────────────────────
  # Unifica o tema que já era dominante (waybar, mako, kitty, wezterm, dunst).
  # Pixel sólido como wallpaper — não conflita com mpvpaper/swww.
  stylix.base16Scheme = {
    scheme  = "Tokyo Night Dark";
    author  = "lucasxll (adaptado de enkia/tokyo-night-vscode-theme)";
    base00  = "1a1b26"; # bg
    base01  = "16161e"; # bg_dark
    base02  = "292e42"; # bg_highlight
    base03  = "565f89"; # comment
    base04  = "9aa5ce"; # dark5
    base05  = "c0caf5"; # fg
    base06  = "cfc9c2"; # fg_dark
    base07  = "d5d6db"; # white
    base08  = "f7768e"; # red
    base09  = "ff9e64"; # orange
    base0A  = "e0af68"; # yellow
    base0B  = "9ece6a"; # green
    base0C  = "73daca"; # teal
    base0D  = "7aa2f7"; # blue
    base0E  = "bb9af7"; # purple
    base0F  = "db4b4b"; # dark_red
  };

  stylix.image = config.lib.stylix.pixel "1a1b26";

  stylix.fonts = {
    monospace = { package = pkgs.nerd-fonts.jetbrains-mono; name = "JetBrainsMono Nerd Font"; };
    sansSerif = { package = pkgs.inter; name = "Inter"; };
    serif     = { package = pkgs.inter; name = "Inter"; };
    sizes = { terminal = 13; applications = 11; desktop = 11; };
  };

  home-manager = {
    useGlobalPkgs        = true;
    useUserPackages      = true;
    extraSpecialArgs     = { inherit inputs; };
    backupFileExtension  = "backup";
    # stylix release-25.05 não injeta o módulo HM automaticamente — declarar aqui
    sharedModules        = [ inputs.stylix.homeModules.stylix ];
    users.lucasxll       = import ../../home/lucasxll/default.nix;
  };

  # ── BOOT ───────────────────────────────────────────────────
  boot = {
    kernelPackages = pkgs.linuxPackages_6_1;
    loader = {
      systemd-boot.enable      = true;
      efi.canTouchEfiVariables = true;
    };
    kernelModules       = [ "kvm-amd" "kvm-intel" "usbcore" "usbhid" "uinput" ];
    extraModprobeConfig = "options usbcore autosuspend=2";
  };

  # ── REDE ───────────────────────────────────────────────────
  networking = {
    hostName              = "nixos";
    networkmanager.enable = true;
  };

  # ── LOCALIZAÇÃO ────────────────────────────────────────────
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

  # ── HARDWARE ───────────────────────────────────────────────
  hardware.bluetooth.enable    = true;
  hardware.keyboard.qmk.enable = true;
  services.pulseaudio.enable   = false;

  # ── DISPLAY ────────────────────────────────────────────────
  services.xserver = {
    enable      = true;
    xkb.layout  = "br";
    xkb.variant = "nodeadkeys";
    windowManager.bspwm.enable = true;
  };

  # Autologin — lockscreen (noctalia) protege após o boot
  services.displayManager.autoLogin = { enable = true; user = "lucasxll"; };
  # "niri" corresponde ao niri.desktop em /share/wayland-sessions/ (programs.niri.enable)
  services.displayManager.defaultSession = "niri";

  # ── ÁUDIO ──────────────────────────────────────────────────
  security.rtkit.enable = true;

  # PAM para hyprlock/noctalia — sem isso a tela de lock não destranca
  security.pam.services.hyprlock = {};
  security.pam.services.noctalia = {};
  services.upower.enable = true;

  # killUserProcesses: evita serviços systemd --user "zumbis" ao trocar TTY
  # (causavam sessão niri "ativa" bloqueando novo login + mouse invertido no bspwm)
  services.logind = {
    killUserProcesses = true;
    lidSwitch         = "suspend";
    lidSwitchDocked   = "ignore";
    # InhibitDelayMaxSec=2: reduz delay de 5s do logind para liberar sessão anterior
    extraConfig = ''
      InhibitDelayMaxSec=2
      HandlePowerKey=suspend
    '';
  };

  # maxlogins=4: evita dois compositors em paralelo (conflito de WAYLAND_DISPLAY)
  security.pam.loginLimits = [{
    domain = "*"; type = "hard"; item = "maxlogins"; value = "4";
  }];

  services.pipewire = {
    enable = true; alsa.enable = true;
    alsa.support32Bit = true; pulse.enable = true;
    wireplumber.enable = true;
  };

  services.printing.enable = true;

  # udisks2: detecção e montagem de pen drives/HDs externos
  services.udisks2.enable = true;
  # gvfs: file picker e barra lateral do Dolphin
  services.gvfs.enable = true;

  # Reinicia mouse-invert-y ao plugar qualquer mouse (find_mice() só roda na init)
  services.udev.extraRules = ''
    SUBSYSTEM=="input", ACTION=="add", ENV{ID_INPUT_MOUSE}=="1", \
      TAG+="systemd", ENV{SYSTEMD_USER_WANTS}="mouse-invert-y.service"
  '';

  # ── ENERGIA ────────────────────────────────────────────────
  services.power-profiles-daemon.enable = false;
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = { governor = "powersave"; turbo = "never"; };
      # schedutil: escala pela carga real — silencioso em idle, acelera quando há trabalho
      charger = { governor = "schedutil"; turbo = "auto"; };
    };
  };

  # Undervolt Ryzen 7 5700U (Zen 2 mobile — não suporta Curve Optimizer)
  # STAPM=10W FAST=12W SLOW=10W TCTL=75°C → fan quase inaudível
  # Para compilações longas: FAST=14000 TCTL=80
  systemd.services.ryzenadj = {
    description = "RyzenAdj undervolt — Ryzen 7 5700U";
    wantedBy = [ "multi-user.target" "suspend.target" "hibernate.target" ];
    after    = [ "multi-user.target" "suspend.target" "hibernate.target" ];
    serviceConfig = {
      Type      = "oneshot";
      ExecStart = toString (pkgs.writeShellScript "ryzenadj-apply" ''
        ${pkgs.ryzenadj}/bin/ryzenadj \
          --stapm-limit=10000 \
          --fast-limit=12000  \
          --slow-limit=10000  \
          --tctl-temp=75

        # ~81% do boost máximo (4300→3500 MHz): Rust/browser sem esquentar
        # Aumente para 4000000 se precisar de mais performance
        for policy in /sys/devices/system/cpu/cpufreq/policy*; do
          echo 3500000 > "$policy/scaling_max_freq" 2>/dev/null || true
        done
      '');
    };
  };

  # ── VIRTUALIZAÇÃO ──────────────────────────────────────────
  virtualisation.docker = {
    enable = true;
    daemon.settings.shutdown-timeout = 10;
  };
  systemd.services.docker.serviceConfig.TimeoutStopSec = "15s";

  # ── VARIÁVEIS DE AMBIENTE ──────────────────────────────────
  environment.sessionVariables = {
    ELECTRON_PASSWORD_STORE = "basic";

    # QT_QPA_PLATFORM não forçado globalmente:
    #   niri → seta wayland no environment{} KDL
    #   bspwm → Qt detecta xcb sozinho
    # Forçar qualquer um aqui quebra a outra sessão.

    _JAVA_AWT_WM_NONREPARENTING = "1";

    OPENSSL_DIR     = "${pkgs.openssl.dev}";
    OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
    PATH            = "$HOME/.cargo/bin:$PATH";

    WASM_OPT = "${pkgs.binaryen}/bin/wasm-opt";
  };

  # ── SERVIÇOS ───────────────────────────────────────────────
  services.dbus.enable           = true;
  services.spice-vdagentd.enable = true;

  # XDG portals — sem config o file picker e screen share não funcionam
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config = {
      common = { default = [ "gtk" ]; };
      niri = {
        default                                       = [ "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast"      = [ "wlr" ];
        "org.freedesktop.impl.portal.RemoteDesktop"   = [ "wlr" ];
        "org.freedesktop.impl.portal.FileChooser"     = [ "gtk" ];
        "org.freedesktop.impl.portal.Settings"        = [ "gtk" ];
      };
    };
  };

  # ── PROGRAMAS ──────────────────────────────────────────────
  programs = {
    firefox.enable = false;
    adb.enable     = true;  # regras udev para ADB sem sudo
    nix-ld = {
      enable    = true;
      libraries = with pkgs; [
        stdenv.cc.cc.lib glibc
        zlib
        freetype fontconfig
        libGL libGLU
        libxkbcommon
        xorg.libX11 xorg.libXext xorg.libXrender
        xorg.libXtst xorg.libXi xorg.libXfixes
        openssl        # ring, rustls, reqwest
        postgresql.lib # sqlx/diesel postgres
        sqlite         # rusqlite, sqlx sqlite
        libclang.lib   # bindgen
      ];
    };
    # programs.zsh.enable: necessário para /etc/shells. Não configurar oh-my-zsh
    # aqui — conflita com Home Manager. Config completa em home/lucasxll/modules/zsh.nix.
    zsh.enable = true;
  };

  # ── FONTES ─────────────────────────────────────────────────
  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono noto-fonts inter ];

  # ── USUÁRIOS ───────────────────────────────────────────────
  users.groups.yurii = {};
  users.users = {
    yurii = {
      isNormalUser       = true;
      group              = "yurii";
      hashedPasswordFile = "/etc/passwdfile";
      shell              = pkgs.zsh;
    };
    lucasxll = {
      isNormalUser = true;
      description  = "LUCASXLL";
      shell        = pkgs.zsh;
      extraGroups  = [
        "networkmanager" "wheel" "docker"
        "libvirt" "libvirtd" "kvm" "qemu-libvirtd"
        "adbusers" "uucp" "uinput" "input" "plugdev"
        "usb" "disk" "cdrom"
      ];
      hashedPassword = "$6$6PEfHzY1BpSqVGXG$j1j7Chn4nt3ehnojWM2mZMaof2LhA2MTN48MNGFzlqZPHjxbgMatRWNU34D6yC5aoeGk1pVc9aTQzc07Px.s8.";
      packages = [];
    };
  };

  security.sudo.extraRules = [{
    users = [ "lucasxll" ];
    commands = [{ command = "ALL"; options = [ "NOPASSWD" ]; }];
  }];

  # ── PACOTES DO SISTEMA ─────────────────────────────────────
  environment.systemPackages = with pkgs; [
    vim git wget htop fastfetch zip unzip

    # Wayland / XWayland
    grim slurp swappy
    wl-clipboard cliphist
    wl-mirror wlr-randr
    playerctl pavucontrol
    xdg-utils libnotify
    wezterm

    vivaldi obsidian onlyoffice-bin_latest gnome-disk-utility
    rofi
    kdePackages.dolphin kdePackages.ark

    # Android Studio com wrapper que garante DISPLAY=:1 e _JAVA_AWT_WM_NONREPARENTING.
    # O wrapper também corrige o Exec= nos .desktop (launchers chamam o binário
    # original, que não tem as vars — o sed abaixo atualiza para $out/bin/).
    (pkgs.symlinkJoin {
      name = "android-studio";
      paths = [ pkgs.android-studio ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/android-studio \
          --set DISPLAY ":1" \
          --set _JAVA_AWT_WM_NONREPARENTING "1"

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

    # Rust toolchain
    rustup
    wasm-pack trunk
    wasm-bindgen-cli
    binaryen   # wasm-opt para wasm-pack
    wabt       # wasm2wat, wasm-validate, wasm-objdump
    nodejs_22

    cargo-watch cargo-generate cargo-edit
    cargo-nextest cargo-audit cargo-expand cargo-flamegraph

    llvmPackages.lld  # linker WASM
    mold              # linker nativo ultrarrápido

    pkg-config openssl openssl.dev
    gcc stdenv.cc.cc

    zulu8 openjdk11 jdk17 jdk21

    docker qemu qemu_kvm virt-manager libvirt acl polkit
    spice spice-gtk spice-protocol libguestfs libusb1 usbutils

    qmk qmk-udev-rules qmk_hid via vial kanata-with-cmd
    sxhkd brightnessctl

    auto-cpufreq libnotify
    xwinwrap mpv yt-dlp

    kdePackages.qtwayland        # Qt6 Wayland
    kdePackages.plasma-integration

    xdg-desktop-portal-gtk

    # Debugger + LSP web
    lldb
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    nodePackages."@tailwindcss/language-server"
    emmet-language-server
    nodePackages.prettier
    nodePackages.eslint
    rust-analyzer rustfmt

    lazygit httpie websocat jq yq-go curlie
    flyctl caddy sqlx-cli mkcert
    btop dust ripgrep fd tokei hyperfine
    lazydocker dive
    wireshark
    fx
  ];

  # KDE service menus do Ark no Dolphin (fora do Plasma)
  environment.pathsToLink = [
    "/share/kservices5"
    "/share/kservices5/ServiceMenus"
    "/share/kio"
    "/share/kio/servicemenus"
  ];

  # ── NIX ────────────────────────────────────────────────────
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store   = true;
    trusted-users         = [ "root" "lucasxll" ];
  };
  nix.gc = {
    automatic = true;
    dates     = "weekly";
    options   = "--delete-older-than 14d";
  };

  # Workaround bug modules-shrunk NixOS 25.05 (overlay em flake.nix)
  boot.initrd.includeDefaultModules = false;
  system.stateVersion = "25.05";
}
