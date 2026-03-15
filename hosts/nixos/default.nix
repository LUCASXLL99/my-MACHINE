# hosts/nixos/default.nix
# Configuração do sistema — apenas o que precisa de root
# Tudo relacionado ao usuário está em home/lucasxll/

{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/hardware/input-left-handed.nix
    ../../modules/nixos/hardware/screen-reflect-x.nix
    ../../modules/nixos/hardware/kanata-keyboard
    ../../modules/nixos/software/secret-service.nix
    ../../modules/nixos/software/yazi-deps.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs    = true;
    useUserPackages  = true;
    extraSpecialArgs = { inherit inputs; };
    users.lucasxll   = import ../../home/lucasxll/default.nix;
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
  hardware.pulseaudio.enable = false;

  # ── DISPLAY ──────────────────────────────────────────────────
  services.xserver = {
    enable      = true;
    xkb.layout  = "br";
    xkb.variant = "nodeadkeys";
    desktopManager.plasma5.enable = true;
    windowManager.bspwm.enable    = true;
  };
  services.displayManager.sddm.enable = true;

  # ── ÁUDIO ────────────────────────────────────────────────────
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true; alsa.enable = true;
    alsa.support32Bit = true; pulse.enable = true;
  };

  # ── IMPRESSÃO ────────────────────────────────────────────────
  services.printing.enable = true;

  # ── ENERGIA ──────────────────────────────────────────────────
  services.power-profiles-daemon.enable = false;
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = { governor = "powersave"; turbo = "never"; };
      charger = { governor = "powersave"; turbo = "never"; };
    };
  };

  # ── VIRTUALIZAÇÃO ────────────────────────────────────────────
  virtualisation.docker.enable = true;

  # ── SERVIÇOS ─────────────────────────────────────────────────
  services.dbus.enable           = true;
  services.spice-vdagentd.enable = true;

  # ── XDG ──────────────────────────────────────────────────────
  xdg.portal = {
    enable       = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # ── PROGRAMAS ────────────────────────────────────────────────
  programs = {
    firefox.enable = false;
    nix-ld = {
      enable    = true;
      libraries = with pkgs; [ stdenv.cc.cc glibc ];
    };
    zsh = {
      enable = true;
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

  # ── FONTES ───────────────────────────────────────────────────
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    noto-fonts
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
      packages = with pkgs; [ kdePackages.kate ];
    };
  };

  # ── PACOTES ──────────────────────────────────────────────────
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim git wget htop fastfetch
    kitty wezterm
    vivaldi obsidian onlyoffice-bin_latest gnome-disk-utility
    python3 python312Packages.pip
    gcc stdenv.cc.cc
    zulu8 openjdk11 jdk17 jdk21
    maven android-studio android-tools cargo-ndk gradle
    docker qemu qemu_kvm virt-manager libvirt acl polkit
    spice spice-gtk spice-protocol libguestfs libusb1 usbutils
    qmk qmk-udev-rules qmk_hid via vial kanata-with-cmd
    sxhkd
    auto-cpufreq libnotify
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
