{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ../../modules/nixos/system/boot.nix
    ../../modules/nixos/system/locale.nix
    ../../modules/nixos/system/network.nix
    ../../modules/nixos/system/users.nix
    ../../modules/nixos/system/packages.nix

    ../../modules/nixos/hardware/sddm-reflect.nix
    ../../modules/nixos/hardware/greetd-autologin.nix
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

  # ── Stylix ───────────────────────────────────────────────────────────────────
  stylix.base16Scheme = {
    scheme = "Tokyo Night Dark";
    author = "lucasxll (adaptado de enkia/tokyo-night-vscode-theme)";
    base00 = "1a1b26"; base01 = "16161e"; base02 = "292e42";
    base03 = "565f89"; base04 = "9aa5ce"; base05 = "c0caf5";
    base06 = "cfc9c2"; base07 = "d5d6db"; base08 = "f7768e";
    base09 = "ff9e64"; base0A = "e0af68"; base0B = "9ece6a";
    base0C = "73daca"; base0D = "7aa2f7"; base0E = "bb9af7";
    base0F = "db4b4b";
  };
  stylix.image = config.lib.stylix.pixel "1a1b26";
  stylix.fonts = {
    monospace = { package = pkgs.nerd-fonts.jetbrains-mono; name = "JetBrainsMono Nerd Font"; };
    sansSerif = { package = pkgs.inter; name = "Inter"; };
    serif     = { package = pkgs.inter; name = "Inter"; };
    sizes     = { terminal = 13; applications = 11; desktop = 11; };
  };

  # ── Home Manager ─────────────────────────────────────────────────────────────
  home-manager = {
    useGlobalPkgs       = true;
    useUserPackages     = true;
    extraSpecialArgs    = { inherit inputs; };
    backupFileExtension = "backup";
    sharedModules = [
      inputs.stylix.homeModules.stylix
      { nixpkgs.overlays = lib.mkForce []; }
    ];
    users.lucasxll = import ../../home/lucasxll/default.nix;
  };

  # ── Hardware ─────────────────────────────────────────────────────────────────
  hardware.bluetooth.enable    = true;
  hardware.keyboard.qmk.enable = true;
  services.pulseaudio.enable   = false;

  # ── Display ──────────────────────────────────────────────────────────────────
  # xserver.enable mantém a sessão bspwm disponível no SDDM.
  # lightdm.enable = false: evita display-manager secundário.
  services.xserver = {
    enable      = true;
    xkb.layout  = "br";
    xkb.variant = "nodeadkeys";
    windowManager.bspwm.enable    = true;
    displayManager.lightdm.enable = false;
  };

  # ── Áudio ────────────────────────────────────────────────────────────────────
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true; alsa.enable = true;
    alsa.support32Bit = true; pulse.enable = true;
    wireplumber.enable = true;
  };

  # ── Serviços ─────────────────────────────────────────────────────────────────
  services.upower.enable         = true;
  services.printing.enable       = true;
  services.udisks2.enable        = true;
  services.gvfs.enable           = true;
  services.dbus.enable           = true;
  services.spice-vdagentd.enable = true;

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

  services.udev.extraRules = ''
    SUBSYSTEM=="input", ACTION=="add", ENV{ID_INPUT_MOUSE}=="1", \
      TAG+="systemd", ENV{SYSTEMD_USER_WANTS}="mouse-invert-y.service"
  '';

  # ── Portal XDG ───────────────────────────────────────────────────────────────
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome pkgs.xdg-desktop-portal-gtk ];
    config.niri = {
      default                                      = [ "gtk" ];
      "org.freedesktop.impl.portal.ScreenCast"    = [ "gnome" ];
      "org.freedesktop.impl.portal.RemoteDesktop" = [ "gnome" ];
      "org.freedesktop.impl.portal.FileChooser"   = [ "gtk" ];
      "org.freedesktop.impl.portal.Settings"      = [ "gtk" ];
    };
  };

  # ── Energia ──────────────────────────────────────────────────────────────────
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

  # ── Virtualização ─────────────────────────────────────────────────────────────
  virtualisation.docker = {
    enable = true;
    daemon.settings.shutdown-timeout = 10;
  };
  systemd.services.docker.serviceConfig.TimeoutStopSec = "15s";

  # ── Nix ───────────────────────────────────────────────────────────────────────
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

  system.stateVersion = "25.05";
}
