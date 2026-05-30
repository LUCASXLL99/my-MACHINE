{ pkgs, ... }:

{
  networking = {
    hostName              = "nixos";
    networkmanager.enable = true;
  };

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

  services.xserver = {
    enable      = true;
    xkb.layout  = "br";
    xkb.variant = "nodeadkeys";
    windowManager.bspwm.enable = true;
  };

  services.displayManager.autoLogin = { enable = true; user = "lucasxll"; };
  # "niri" corresponde ao niri.desktop em /share/wayland-sessions/
  services.displayManager.defaultSession = "niri";

  security.pam.services.hyprlock = {};
  security.pam.services.noctalia = {};

  # killUserProcesses: evita sessão niri "morta" bloqueando novo login
  services.logind = {
    killUserProcesses = true;
    lidSwitch         = "suspend";
    lidSwitchDocked   = "ignore";
    extraConfig = ''
      InhibitDelayMaxSec=2
      HandlePowerKey=suspend
    '';
  };

  # maxlogins=4: evita dois compositors rodando em paralelo (conflito WAYLAND_DISPLAY)
  security.pam.loginLimits = [{
    domain = "*"; type = "hard"; item = "maxlogins"; value = "4";
  }];

  services.dbus.enable           = true;
  services.spice-vdagentd.enable = true;

  virtualisation.docker = {
    enable                    = true;
    daemon.settings.shutdown-timeout = 10;
  };
  systemd.services.docker.serviceConfig.TimeoutStopSec = "15s";

  environment.sessionVariables = {
    ELECTRON_PASSWORD_STORE     = "basic";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    OPENSSL_DIR                 = "${pkgs.openssl.dev}";
    OPENSSL_LIB_DIR             = "${pkgs.openssl.out}/lib";
    PATH                        = "$HOME/.cargo/bin:$PATH";
    WASM_OPT                    = "${pkgs.binaryen}/bin/wasm-opt";
  };

  programs = {
    firefox.enable = false;
    adb.enable     = true;
    zsh.enable     = true;  # necessário para zsh aparecer em /etc/shells
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc.lib glibc zlib
        freetype fontconfig
        libGL libGLU libxkbcommon
        xorg.libX11 xorg.libXext xorg.libXrender
        xorg.libXtst xorg.libXi xorg.libXfixes
        openssl postgresql.lib sqlite libclang.lib
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    vim git wget htop fastfetch zip unzip

    # Wayland
    grim slurp swappy wl-clipboard cliphist wl-mirror wlr-randr
    playerctl pavucontrol xdg-utils libnotify wezterm

    # Apps
    vivaldi obsidian onlyoffice-bin_latest gnome-disk-utility
    rofi kdePackages.dolphin kdePackages.ark

    # Android Studio com wrapper para DISPLAY=:1 (xwayland-satellite)
    (pkgs.symlinkJoin {
      name       = "android-studio";
      paths      = [ pkgs.android-studio ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild  = ''
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

    # Rust / WASM
    rustup wasm-pack trunk wasm-bindgen-cli binaryen wabt nodejs_22
    cargo-watch cargo-generate cargo-edit cargo-nextest
    cargo-audit cargo-expand cargo-flamegraph
    llvmPackages.lld mold pkg-config openssl openssl.dev

    # Compiladores / JVM
    gcc stdenv.cc.cc
    zulu8 openjdk11 jdk17 jdk21

    # Virtualização
    docker qemu qemu_kvm virt-manager libvirt acl polkit
    spice spice-gtk spice-protocol libguestfs libusb1 usbutils

    # Teclado
    qmk qmk-udev-rules qmk_hid via vial kanata-with-cmd
    sxhkd brightnessctl

    auto-cpufreq libnotify xwinwrap mpv yt-dlp

    # Qt6 / KDE
    kdePackages.qtwayland kdePackages.plasma-integration
    xdg-desktop-portal-gtk

    # Dev tools
    lldb
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    nodePackages."@tailwindcss/language-server"
    emmet-language-server nodePackages.prettier nodePackages.eslint
    rust-analyzer rustfmt
    lazygit httpie websocat jq yq-go curlie
    flyctl caddy sqlx-cli mkcert
    btop dust ripgrep fd tokei hyperfine
    lazydocker dive wireshark fx
  ];

  # Menus de contexto do Ark no Dolphin fora do Plasma
  environment.pathsToLink = [
    "/share/kservices5"
    "/share/kservices5/ServiceMenus"
    "/share/kio"
    "/share/kio/servicemenus"
  ];
}
