# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, inputs, ... }: {

  # ============================================================
  # IMPORTS
  # ============================================================
  imports = [
    ./hardware-configuration.nix
    ./nixos-Modules/Modules-Hardware/screen-reflect-x.nix 
    ./nixos-Modules/Modules-Hardware/kanata-keyboard.nix
    ./nixos-Modules/Modules-Hardware/input-left-handed.nix
  ];


  # ============================================================
  # BOOT
  # ============================================================
  boot = {
    loader = {
      systemd-boot.enable      = true;
      efi.canTouchEfiVariables = true;
    };

    kernelModules = [ "kvm-amd" "kvm-intel" "usbcore" "usbhid" ];

    extraModprobeConfig = ''
      options usbcore autosuspend=2
    '';
  };


  # ============================================================
  # NETWORK
  # ============================================================
  networking = {
    hostName             = "nixos";
    networkmanager.enable = true;
    # wireless.enable = true;  # wpa_supplicant (desativado; usando NetworkManager)
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };


  # ============================================================
  # LOCALIZAÇÃO E IDIOMA
  # ============================================================
  time.timeZone = "America/Belem";

  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS        = "pt_BR.UTF-8";
      LC_IDENTIFICATION = "pt_BR.UTF-8";
      LC_MEASUREMENT    = "pt_BR.UTF-8";
      LC_MONETARY       = "pt_BR.UTF-8";
      LC_NAME           = "pt_BR.UTF-8";
      LC_NUMERIC        = "pt_BR.UTF-8";
      LC_PAPER          = "pt_BR.UTF-8";
      LC_TELEPHONE      = "pt_BR.UTF-8";
      LC_TIME           = "pt_BR.UTF-8";
    };
  };


  # ============================================================
  # HARDWARE
  # ============================================================
  hardware = {
    bluetooth.enable   = true;
    pulseaudio.enable  = false; # substituído pelo PipeWire
    keyboard.qmk.enable = true; # udev rules para flashar teclados QMK sem sudo
  };


  # ============================================================
  # DISPLAY / DESKTOP (KDE Plasma + bspwm | X11)
  # SDDM permite escolher entre KDE e bspwm na tela de login.
  # ============================================================
  services.xserver = {
    enable = true;
    layout    = "br";
    xkbVariant = "nodeadkeys";

    desktopManager.plasma5.enable = true;

    # bspwm disponível como opção alternativa ao KDE no SDDM
    windowManager.bspwm.enable = true;

    displayManager = {
      # autoLogin = {
      # enable = true;
      #  user   = "lucasxll";
      # };
    };
  };

  services.displayManager.sddm.enable = true;

  console.keyMap = "br-abnt2";


  # ============================================================
  # ÁUDIO (PipeWire)
  # ============================================================
  security.rtkit.enable = true;

  services.pipewire = {
    enable          = true;
    alsa.enable     = true;
    alsa.support32Bit = true;
    pulse.enable    = true;
    # jack.enable = true;  # Descomente para suporte a aplicações JACK
  };


  # ============================================================
  # IMPRESSÃO
  # ============================================================
  services.printing.enable = true;


  # ============================================================
  # ENERGIA (auto-cpufreq)
  # ============================================================
  services.power-profiles-daemon.enable = false; # desativado; usando auto-cpufreq

  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = { governor = "powersave"; turbo = "never"; };
      charger = { governor = "powersave"; turbo = "never"; };
    };
  };


  # ============================================================
  # VIRTUALIZAÇÃO
  # ============================================================
  virtualisation.docker.enable = true;

  # virtualisation.libvirtd.enable = true;
  # virtualisation.qemu.enable    = true;
  # virtualisation.kvm.enable     = true;


  # ============================================================
  # SERVIÇOS DO SISTEMA
  # ============================================================
  services = {
    dbus.enable          = true;
    spice-vdagentd.enable = true; # SPICE: melhor suporte a vídeo/USB em VMs
  };


  # ============================================================
  # XDG / PORTAIS
  # ============================================================
  xdg.portal = {
    enable       = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };


  # ============================================================
  # PROGRAMAS DO SISTEMA
  # ============================================================
  programs = {
    firefox.enable = false;
    # hyprland removido completamente

    # nix-ld: permite rodar binários dinâmicos não-NixOS
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc
        glibc
      ];
    };

    # ---- ZSH com autocompletar automático ----
    # zsh-autosuggestions: sugere comandos enquanto você digita (←  ou End para aceitar)
    # zsh-syntax-highlighting: colore comandos válidos/inválidos em tempo real
    zsh = {
      enable = true;
      autosuggestions.enable       = true;
      syntaxHighlighting.enable    = true;
      enableCompletion             = true;
      ohMyZsh = {
        enable  = true;
        theme   = "robbyrussell";
        plugins = [ "git" "docker" "sudo" "history" ];
      };
    };
  };


  # ============================================================
  # USUÁRIOS
  # ============================================================
  users.groups.yurii = {};

  users.users = {
    yurii = {
      isNormalUser     = true;
      group            = "yurii";
      hashedPasswordFile = "/etc/passwdfile";
      shell            = pkgs.zsh; # usa zsh como shell padrão
    };

    lucasxll = {
      isNormalUser = true;
      description  = "LUCASXLL";
      shell        = pkgs.zsh; # usa zsh como shell padrão
      extraGroups  = [
        "networkmanager" "wheel"
        "docker"
        "libvirt" "libvirtd" "kvm" "qemu-libvirtd"
        "adbusers"
        "uucp" "uinput" "input" "plugdev"
        "usb" "disk" "cdrom"
      ];
      hashedPassword = "$6$6PEfHzY1BpSqVGXG$j1j7Chn4nt3ehnojWM2mZMaof2LhA2MTN48MNGFzlqZPHjxbgMatRWNU34D6yC5aoeGk1pVc9aTQzc07Px.s8.";
      packages = with pkgs; [
        kate
        # thunderbird
      ];
    };
  };


  # ============================================================
  # PACOTES DO SISTEMA
  # ============================================================
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # --- Utilitários base ---
    vim
    git
    wget
    htop
    fastfetch
    lf

    # --- Terminais ---
    # kitty: mantido como fallback
    kitty
    # wezterm: terminal principal — multiplexação nativa (abas/splits/painéis),
    #          GPU-accelerated, configurável em Lua, ótimo no X11
    wezterm

    # --- Browser / Produtividade ---
    vivaldi
    obsidian
    onlyoffice-bin_latest
    bitwarden-desktop
    gnome.gnome-disk-utility

    # --- Programação: Python ---
    python3
    python312Packages.pip

    # --- Programação: C/C++ ---
    gcc
    libstdcxx5
    stdenv.cc.cc

    # --- Programação: Java / Android ---
    zulu8
    openjdk11
    jdk17
    jdk21
    maven
    android-studio
    android-tools
    cargo-ndk
    gradle

    # --- Infraestrutura ---
    docker
    qemu
    qemu_kvm
    virt-manager
    libvirt
    acl
    polkit

    # --- SPICE (VMs) ---
    spice
    spice-gtk
    spice-protocol
    libguestfs
    libusb
    usbutils

    # --- VirtualBox (módulos para kernels alternativos) ---
    linuxKernel.packages.linux_zen.virtualbox
    linuxKernel.packages.linux_xanmod_stable.virtualbox
    linuxKernel.packages.linux_lqx.virtualbox

    # --- QMK / Teclado ---
    qmk              # compilar e flashar firmware
    qmk-udev-rules
    qmk_hid
    via
    vial
    kanata-with-cmd
    # kanata  # redundante; kanata-with-cmd já inclui o binário base

    # --- bspwm (X11 Tiling WM) ---
    # Escolha disponível no SDDM junto ao KDE Plasma
    sxhkd        # gerenciador de atalhos do bspwm (obrigatório)
    picom        # compositor: animações, blur, sombras, cantos arredondados
    polybar      # barra de status
    rofi         # launcher de aplicativos (super + d)
    feh          # wallpaper
    dunst        # notificações (substitui mako que é Wayland-only)
    flameshot    # screenshots

    # --- Outros ---
    home-manager
    auto-cpufreq
    libnotify    # comando notify-send (usado pelo dunst)
  ];


  # ============================================================
  # NIX
  # ============================================================
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data were taken. Leave as-is after the
  # first install (see 'man configuration.nix').
  system.stateVersion = "25.05";
}
