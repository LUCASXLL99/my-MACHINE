# hosts/nixos/default.nix

{ config, pkgs, lib, inputs, ... }:

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

  # ── STYLIX ───────────────────────────────────────────────────
  stylix.base16Scheme = {
    scheme  = "Tokyo Night Dark";
    author  = "lucasxll (adaptado de enkia/tokyo-night-vscode-theme)";
    base00  = "1a1b26";
    base01  = "16161e";
    base02  = "292e42";
    base03  = "565f89";
    base04  = "9aa5ce";
    base05  = "c0caf5";
    base06  = "cfc9c2";
    base07  = "d5d6db";
    base08  = "f7768e";
    base09  = "ff9e64";
    base0A  = "e0af68";
    base0B  = "9ece6a";
    base0C  = "73daca";
    base0D  = "7aa2f7";
    base0E  = "bb9af7";
    base0F  = "db4b4b";
  };

  stylix.image = config.lib.stylix.pixel "1a1b26";

  stylix.fonts = {
    monospace = { package = pkgs.nerd-fonts.jetbrains-mono; name = "JetBrainsMono Nerd Font"; };
    sansSerif = { package = pkgs.inter; name = "Inter"; };
    serif     = { package = pkgs.inter; name = "Inter"; };
    sizes = { terminal = 13; applications = 11; desktop = 11; };
  };

  home-manager = {
    useGlobalPkgs    = true;
    useUserPackages  = true;
    extraSpecialArgs = { inherit inputs; };
    backupFileExtension = "backup";
    sharedModules = [
      inputs.stylix.homeModules.stylix
      # stylix.homeModules.stylix define nixpkgs.overlays internamente,
      # o que dispara o aviso de useGlobalPkgs. Anulamos aqui para silenciá-lo
      # sem perder nenhuma funcionalidade (o pkgs global já inclui os overlays).
      { nixpkgs.overlays = lib.mkForce []; }
    ];
    users.lucasxll = import ../../home/lucasxll/default.nix;
  };

  # ── BOOT ─────────────────────────────────────────────────────
  boot = {
    kernelPackages = pkgs.linuxPackages_6_6;
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

  # O autologin é configurado exclusivamente via Autologin.* em sddm-reflect.nix,
  # que funciona corretamente com SDDM Qt6 + tema customizado.

  # ── ÁUDIO ────────────────────────────────────────────────────
  security.rtkit.enable = true;

  security.pam.services.hyprlock = {};
  security.pam.services.noctalia = {};
  services.upower.enable = true;

  services.logind = {
    killUserProcesses = true;
    lidSwitch         = "suspend";
    lidSwitchDocked   = "ignore";
    extraConfig = ''
      InhibitDelayMaxSec=2
      HandlePowerKey=suspend
    '';
  };

  security.pam.loginLimits = [{
    domain = "*"; type = "hard"; item = "maxlogins"; value = "4";
  }];

  services.pipewire = {
    enable = true; alsa.enable = true;
    alsa.support32Bit = true; pulse.enable = true;
    wireplumber.enable = true;
  };

  services.printing.enable = true;

  services.udisks2.enable = true;
  services.gvfs.enable = true;

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
      charger = { governor = "schedutil"; turbo = "auto"; };
    };
  };

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

        for policy in /sys/devices/system/cpu/cpufreq/policy*; do
          echo 3500000 > "$policy/scaling_max_freq" 2>/dev/null || true
        done
      '');
    };
  };

  # ── VIRTUALIZAÇÃO ────────────────────────────────────────────
  virtualisation.docker = {
    enable = true;
    daemon.settings.shutdown-timeout = 10;
  };
  systemd.services.docker.serviceConfig.TimeoutStopSec = "15s";

  # ── VARIÁVEIS DE AMBIENTE ────────────────────────────────────
  environment.sessionVariables = {
    _JAVA_AWT_WM_NONREPARENTING = "1";
    OPENSSL_DIR     = "${pkgs.openssl.dev}";
    OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
    PATH            = "$HOME/.cargo/bin:$PATH";
    WASM_OPT        = "${pkgs.binaryen}/bin/wasm-opt";
  };

  # ── SERVIÇOS ─────────────────────────────────────────────────
  services.dbus.enable           = true;
  services.spice-vdagentd.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config = {
      common = { default = [ "gtk" ]; };
      niri = {
        default                                      = [ "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast"    = [ "wlr" ];
        "org.freedesktop.impl.portal.RemoteDesktop" = [ "wlr" ];
        "org.freedesktop.impl.portal.FileChooser"   = [ "gtk" ];
        "org.freedesktop.impl.portal.Settings"      = [ "gtk" ];
      };
    };
  };

  # ── PROGRAMAS ────────────────────────────────────────────────
  programs = {
    firefox.enable = false;
    adb.enable     = true;
    nix-ld = {
      enable    = true;
      libraries = with pkgs; [
        stdenv.cc.cc.lib glibc zlib
        freetype fontconfig
        libGL libGLU libxkbcommon
        xorg.libX11 xorg.libXext xorg.libXrender
        xorg.libXtst xorg.libXi xorg.libXfixes
        openssl postgresql.lib sqlite libclang.lib
      ];
    };
    zsh.enable = true;
  };

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

  security.sudo.extraRules = [{
    users    = [ "lucasxll" ];
    commands = [{ command = "ALL"; options = [ "NOPASSWD" ]; }];
  }];

  # ── PACOTES DO SISTEMA ───────────────────────────────────────
  environment.systemPackages = with pkgs; [
    vim git wget htop fastfetch
    zip unzip

    grim slurp swappy
    wl-clipboard cliphist
    wl-mirror wlr-randr
    playerctl pavucontrol
    xdg-utils libnotify
    wezterm

    vivaldi obsidian onlyoffice-bin_latest gnome-disk-utility
    rofi
    kdePackages.dolphin kdePackages.ark

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

    rustup
    wasm-pack trunk
    wasm-bindgen-cli
    binaryen
    wabt

    nodejs_22

    cargo-watch cargo-generate cargo-edit
    cargo-nextest cargo-audit cargo-expand cargo-flamegraph

    llvmPackages.lld
    mold

    pkg-config openssl openssl.dev
    gcc stdenv.cc.cc
    zulu8 openjdk11 jdk17 jdk21

    docker qemu qemu_kvm virt-manager libvirt acl polkit
    spice spice-gtk spice-protocol libguestfs libusb1 usbutils

    qmk qmk-udev-rules qmk_hid via vial kanata-with-cmd
    sxhkd brightnessctl

    auto-cpufreq libnotify
    xwinwrap mpv yt-dlp

    kdePackages.qtwayland
    kdePackages.plasma-integration

    xdg-desktop-portal-gtk

    lldb

    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    nodePackages."@tailwindcss/language-server"
    emmet-language-server
    nodePackages.prettier
    nodePackages.eslint

    rust-analyzer
    rustfmt

    lazygit httpie websocat jq yq-go curlie

    flyctl
    caddy
    sqlx-cli
    mkcert

    btop dust ripgrep fd tokei hyperfine

    lazydocker dive

    wireshark

    fx
  ];

  environment.pathsToLink = [
    "/share/kservices5"
    "/share/kservices5/ServiceMenus"
    "/share/kio"
    "/share/kio/servicemenus"
  ];

  # ── NIX ──────────────────────────────────────────────────────
  # Caches declarados em nix.settings (não em nixConfig no flake):
  # nixConfig só é respeitado com --accept-flake-config; nix.settings
  # sempre se aplica ao nixos-rebuild, evitando compilação local do niri.
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store   = true;
    trusted-users         = [ "root" "lucasxll" ];
    substituters = [
      "https://cache.nixos.org"
      "https://noctalia.cachix.org"
      "https://pi.cachix.org"
      "https://niri.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "pi.cachix.org-1:lGeoGJaZ5ZDabuRzkcD5EBTNnDM4HJ1vqeOxlWk1Flk="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfry9N+KvbD843ZCEMiypnAjAK0Oo="
    ];
  };
  nix.gc = {
    automatic = true;
    dates     = "weekly";
    options   = "--delete-older-than 14d";
  };

  boot.initrd.includeDefaultModules = false;
  system.stateVersion = "25.05";
}
