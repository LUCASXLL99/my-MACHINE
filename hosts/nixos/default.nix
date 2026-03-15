# hosts/nixos/default.nix
# Configuração do sistema — apenas o que precisa de root
# Tudo relacionado ao usuário está em home/lucasxll/

{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    # ── Módulos de hardware ──────────────────────────────────
    ../../modules/nixos/hardware/input-left-handed.nix
    ../../modules/nixos/hardware/screen-reflect-x.nix
    ../../modules/nixos/hardware/kanata-keyboard

    # ── Módulos de software do sistema ──────────────────────
    ../../modules/nixos/software/secret-service.nix
    ../../modules/nixos/software/yazi-deps.nix

    # ── Home Manager integrado ao sistema ───────────────────
    inputs.home-manager.nixosModules.home-manager
  ];

  # ── Home Manager ────────────────────────────────────────────
  home-manager = {
    useGlobalPkgs   = true;   # usa o mesmo nixpkgs do sistema
    useUserPackages = true;   # instala pacotes do home no perfil do usuário
    extraSpecialArgs = { inherit inputs; };
    users.lucasxll = import ../../home/lucasxll/default.nix;
  };


  # ============================================================
  # BOOT
  # ============================================================
  boot = {
       kernelPackages = pkgs.linuxPackages_6_1;
    loader = {
      systemd-boot.enable      = true;
      efi.canTouchEfiVariables = true;
    };
    kernelModules = [ "kvm-amd" "kvm-intel" "usbcore" "usbhid" ];
    extraModprobeConfig = ''
      options usbcore autosuspend=2
    '';
  };

# Desativa compressão de módulos do kernel (evita bug modules-shrunk)
nixpkgs.overlays = [
  (final: prev: {
    makeModulesClosure = x: prev.makeModulesClosure (x // { allowMissing = true; });
  })
];
  # ============================================================
  # REDE
  # ============================================================
  networking = {
    hostName              = "nixos";
    networkmanager.enable = true;
  };


  # ============================================================
  # LOCALIZAÇÃO
  # ============================================================
  time.timeZone      = "America/Belem";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
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
  console.keyMap = "br-abnt2";


  # ============================================================
  # HARDWARE
  # ============================================================
  hardware = {
    bluetooth.enable    = true;
    pulseaudio.enable   = false;
    keyboard.qmk.enable = true;
  };


  # ============================================================
  # DISPLAY / DESKTOP
  # ============================================================
  services.xserver = {
    enable     = true;
    xkb.layout  = "br";
    xkb.variant = "nodeadkeys";
    desktopManager.plasma5.enable  = true;
    windowManager.bspwm.enable     = true;
    displayManager = {};
  };

  services.displayManager.sddm.enable = true;


  # ============================================================
  # ÁUDIO
  # ============================================================
  security.rtkit.enable = true;
  services.pipewire = {
    enable            = true;
    alsa.enable       = true;
    alsa.support32Bit = true;
    pulse.enable      = true;
  };


  # ============================================================
  # IMPRESSÃO
  # ============================================================
  services.printing.enable = true;


  # ============================================================
  # ENERGIA
  # ============================================================
  services.power-profiles-daemon.enable = false;
  services.auto-cpufreq = {
    enable   = true;
    settings = {
      battery = { governor = "powersave"; turbo = "never"; };
      charger = { governor = "powersave"; turbo = "never"; };
    };
  };


  # ============================================================
  # VIRTUALIZAÇÃO
  # ============================================================
  virtualisation.docker.enable = true;


  # ============================================================
  # SERVIÇOS DO SISTEMA
  # ============================================================
  services.dbus.enable           = true;
  services.spice-vdagentd.enable = true;


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
    nix-ld = {
      enable    = true;
      libraries = with pkgs; [ stdenv.cc.cc glibc ];
    };
    zsh = {
      enable                    = true;
      autosuggestions.enable    = true;
      syntaxHighlighting.enable = true;
      enableCompletion          = true;
      ohMyZsh = {
        enable  = true;
        theme   = "robbyrussell";
        plugins = [ "git" "docker" "sudo" "history" ];
      };
    };
  };


  # ============================================================
  # FONTES
  # ============================================================
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
  ];


  # ============================================================
  # USUÁRIOS
  # ============================================================
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
      packages = with pkgs; [ kdePackages.kate ];
    };
  };


  # ============================================================
  # PACOTES DO SISTEMA
  # ============================================================
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # --- Utilitários base ---
    vim git wget htop fastfetch

    # --- Terminais ---
    kitty wezterm

    # --- Browser / Produtividade ---
    vivaldi obsidian onlyoffice-bin_latest
    gnome-disk-utility

    # --- Programação: Python ---
    python3 python312Packages.pip

    # --- Programação: C/C++ ---
    gcc stdenv.cc.cc

    # --- Programação: Java / Android ---
    zulu8 openjdk11 jdk17 jdk21
    maven android-studio android-tools cargo-ndk gradle

    # --- Infraestrutura ---
    docker qemu qemu_kvm virt-manager libvirt acl polkit

    # --- SPICE ---
    spice spice-gtk spice-protocol libguestfs libusb1 usbutils

    # --- VirtualBox ---

    # --- QMK / Teclado ---
    qmk qmk-udev-rules qmk_hid via vial kanata-with-cmd

    # --- bspwm ---
    sxhkd  # sxhkd precisa estar no sistema

    # --- Outros ---
    auto-cpufreq libnotify
  ];


  # ============================================================
  # NIX
  # ============================================================
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    # Otimizações de build
    auto-optimise-store = true;
  };

  nix.gc = {
    automatic = true;
    dates     = "weekly";
    options   = "--delete-older-than 14d";
  };

  system.stateVersion = "25.05";
}
