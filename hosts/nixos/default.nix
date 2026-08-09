{ config, pkgs, lib, inputs, noctalia-patched, tui-kan-pkg, ... }:

{
  imports = [
    ../../modules/nixos/system/boot.nix
    ../../modules/nixos/system/locale.nix
    ../../modules/nixos/system/network.nix
    ../../modules/nixos/system/users.nix
    ../../modules/nixos/system/packages.nix
    ../../modules/nixos/software/no-keyring.nix
    ../../modules/nixos/software/yazi-deps.nix
    ../../modules/nixos/software/yazi-deps.nix
    ../../modules/nixos/software/mango.nix
    ../../modules/nixos/software/rust-dev.nix
    ../../modules/nixos/software/wine.nix
    ../../modules/nixos/software/wallcards.nix
    ../../modules/nixos/software/kbuildsycoca-autofix.nix
    ../../modules/nixos/software/default-terminal.nix
    ../../modules/nixos/software/obs-wayland.nix

    ../../modules/nixos/hardware/greetd-autologin.nix
    ./hardware-configuration.nix
    ../../modules/nixos/hardware/input-left-handed.nix
    ../../modules/nixos/hardware/bluetooth-audio.nix
    ../../modules/nixos/hardware/kanata-keyboard

    inputs.home-manager.nixosModules.home-manager
    inputs.stylix.nixosModules.stylix
  ];

  # stylix
  # enable=true necessário: sem ele o Stylix fica inerte (default é false) e
  # todos os targets abaixo não aplicam nada.
  stylix.enable = true;
  stylix.base16Scheme = {
    scheme = "Nord";
    author = "lucasxll (Nord, base16)";
    # Escuro, neutro, alto contraste (texto e5e9f0 quase branco sobre 2e3440).
    # Pedido: "tema neutro mais fácil de ler caracteres em todo o sistema".
    base00 = "2e3440"; base01 = "3b4252"; base02 = "434c5e";
    base03 = "4c566a"; base04 = "d8dee9"; base05 = "e5e9f0";
    base06 = "eceff4"; base07 = "8fbcbb"; base08 = "bf616a";
    base09 = "d08770"; base0A = "ebcb8b"; base0B = "a3be8c";
    base0C = "88c0d0"; base0D = "81a1c1"; base0E = "b48ead";
    base0F = "5e81ac";
  };
  stylix.image = config.lib.stylix.pixel "base00"; # #2e3440 (fundo do esquema)
  stylix.fonts = {
    monospace = { package = pkgs.nerd-fonts.jetbrains-mono; name = "JetBrainsMono Nerd Font"; };
    sansSerif = { package = pkgs.inter; name = "Inter"; };
    serif     = { package = pkgs.inter; name = "Inter"; };
    sizes     = { terminal = 13; applications = 11; desktop = 11; };
  };

  # home-manager
  home-manager = {
    useGlobalPkgs       = true;
    useUserPackages     = true;
    extraSpecialArgs    = { inherit inputs noctalia-patched tui-kan-pkg; };
    backupFileExtension = "backup";
    # sharedModules do stylix NÃO entram aqui: o módulo NixOS do stylix já faz
    # autoImport (stylix.homeManagerIntegration.autoImport=true) — importar o
    # homeModules.stylix manualmente aqui duplicava a definição de
    # stylix.base16 e quebrava a avaliação.
    sharedModules = [
      inputs.mango.hmModules.mango
    ];
    users.lucasxll = import ../../home/lucasxll/default.nix;
  };

  # hardware
  hardware.bluetooth.enable    = true;
  hardware.keyboard.qmk.enable = true;
  services.pulseaudio.enable   = false;

  # dconf: antes vinha "de brinde" com o xdg-desktop-portal-gnome (que
  # tirei quando troquei o portal pra wlr, ver mango.nix). Sem isso, o
  # dbus-service ca.desrt.dconf some do sistema e o home-manager quebra
  # na etapa dconfSettings ("ServiceUnknown: ca.desrt.dconf") — mesmo com
  # 0 settings de dconf configurados, o home-manager sempre roda essa
  # etapa de ativação.
  programs.dconf.enable = true;

  # GPU (AMD/mesa) — sem isso, captura de tela via PipeWire (OBS) fica preta,
  # pois depende de DMA-BUF/VAAPI que só existe com aceleração habilitada.
  hardware.graphics = {
    enable       = true;
    enable32Bit  = true; # útil p/ apps 32-bit (ex: alguns emuladores/jogos), sem custo real
    extraPackages = with pkgs; [
      mesa
      libva
    ];
  };

  # display — sessão Wayland (mango) via greetd. X11/bspwm era legado da era
  # niri/hyprland e nunca roda: o xkb layout é configurado no mango config
  # (wayland/mango.nix: xkb_rules_layout). services.xserver desligado pra não
  # instalar o stack X11 inteiro à toa.
  services.xserver = {
    enable = false;
  };

  # audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true; alsa.enable = true;
    alsa.support32Bit = true; pulse.enable = true;
    wireplumber.enable = true;
  };

  # servicos
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

  # Reaplica a inversão de eixo do mouse quando um mouse é plugado. O serviço
  # real é `mouse-invert` (systemd system, ver input-left-handed.nix) — a
  # TAG "systemd" com SYSTEMD_USER_WANTS só alcança o manager do *usuário*, e
  # o serviço não existe lá. Usamos caminho absoluto no store (obrigatório p/
  # udev rules: o sandbox de build não tem /run/current-system) + RUN.
  services.udev.extraRules = ''
    SUBSYSTEM=="input", ACTION=="add", ENV{ID_INPUT_MOUSE}=="1", \
      RUN+="${pkgs.systemd}/bin/systemctl restart mouse-invert"
  '';

  # portal xdg
  # xdg-desktop-portal-wlr (não -gnome) para ScreenCast/RemoteDesktop: o
  # mango, ao contrário do niri, não imita a interface do Mutter — ver
  # modules/nixos/software/mango.nix, que já instala o pacote wlr e
  # habilita `xdg.portal.wlr.enable`. gtk continua cuidando de
  # FileChooser/Settings normalmente.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.mango = {
      default                                      = [ "gtk" ];
      "org.freedesktop.impl.portal.ScreenCast"    = [ "wlr" ];
      "org.freedesktop.impl.portal.RemoteDesktop" = [ "wlr" ];
      "org.freedesktop.impl.portal.FileChooser"   = [ "gtk" ];
      "org.freedesktop.impl.portal.Settings"      = [ "gtk" ];
    };
  };

  # energia
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

  # virtualizacao
  virtualisation.docker = {
    enable = true;
    daemon.settings.shutdown-timeout = 10;
  };
  systemd.services.docker.serviceConfig.TimeoutStopSec = "15s";

  # nix
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store   = true;
    trusted-users         = [ "root" "lucasxll" ];
    substituters = [
      "https://cache.nixos.org"
      "https://noctalia.cachix.org"
      "https://pi.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "pi.cachix.org-1:lGeoGJaZ5ZDabuRzkcD5EBTNnDM4HJ1vqeOxlWk1Flk="
    ];
  };
  nix.gc = {
    automatic = true;
    dates     = "weekly";
    options   = "--delete-older-than 14d";
  };

  system.stateVersion = "25.05";
}
