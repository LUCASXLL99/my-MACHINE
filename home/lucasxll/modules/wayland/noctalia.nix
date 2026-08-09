{ config, pkgs, inputs, lib, ... }:

{
  programs.noctalia-shell = {
    enable = true;

    colors = {
      mSurface          = "#1a1b26";
      mSurfaceVariant   = "#24283b";
      mHover            = "#292e42";
      mOnHover          = "#c0caf5";
      mPrimary          = "#7aa2f7";
      mOnPrimary        = "#1a1b26";
      mSecondary        = "#9aa5ce";
      mOnSecondary      = "#1a1b26";
      mTertiary         = "#bb9af7";
      mOnTertiary       = "#1a1b26";
      mOnSurface        = "#c0caf5";
      mOnSurfaceVariant = "#9aa5ce";
      mOutline          = "#3d4466";
      mError            = "#f7768e";
      mOnError          = "#1a1b26";
      mShadow           = "#000000";
    };

    settings = {
      bar = {
        position          = "top";
        density           = "compact";
        backgroundOpacity = 0.92;
        marginVertical    = 4;
        marginHorizontal  = 4;
        frameRadius       = 12;
        outerCorners      = true;
        widgets = {
          left   = [ { id = "Launcher"; } { id = "Clock"; } { id = "ActiveWindow"; } ];
          center = [ { id = "Workspace"; } ];
          right  = [ { id = "Tray"; } { id = "NotificationHistory"; } { id = "Battery"; warningThreshold = 20; } { id = "Volume"; } { id = "Brightness"; } { id = "ControlCenter"; } ];
        };
      };

      general = {
        radiusRatio            = 0.8;
        enableShadows          = true;
        enableBlurBehind       = true;
        lockOnSuspend          = true;
        showChangelogOnStartup = false;
        telemetryEnabled       = false;
        compactLockScreen      = false;
        lockScreenAnimations   = false;
      };

      location = {
        name            = "Fortaleza, Brasil";
        autoLocate      = true;
        useFahrenheit   = false;
        use12hourFormat = false;
        weatherEnabled  = false;
      };

      colorSchemes = {
        predefinedScheme   = "custom";
        useWallpaperColors = false;
        darkMode           = true;
        schedulingMode     = "off";
      };

      # Rotação automática dos wallpapers 4K (portados do mango-fedora).
      # mpvpaper (wallpaper.nix) foi desativado pra não brigar — o vídeo
      # wallpaper.mp4 ainda dá pra ligar manualmente via SUPER+Semicolon.
      wallpaper = {
        enabled                   = true;
        directory                 = "${config.home.homeDirectory}/Pictures/wallpapers";
        automationEnabled         = true;
        wallpaperChangeMode       = "random";
        randomIntervalSec         = 600;
        transitionDuration        = 2000;
        transitionType            = [ "fade" ];
        fillMode                  = "crop";
        setWallpaperOnAllMonitors = true;
      };

      notifications = {
        enabled                 = true;
        location                = "top_left";
        lowUrgencyDuration      = 4;
        normalUrgencyDuration   = 8;
        criticalUrgencyDuration = 0;
        respectExpireTimeout    = false;
        sounds.enabled          = false;
      };

      idle = {
        enabled          = true;
        lockTimeout      = 300;
        screenOffTimeout = 360;
        suspendTimeout   = 1800;
        fadeDuration     = 5;
      };

      appLauncher = {
        position               = "center";
        sortByMostUsed         = true;
        terminalCommand        = "wezterm -e";
        viewMode               = "list";
        showCategories         = true;
        enableClipboardHistory = true;
      };

      audio      = { volumeStep = 5; volumeOverdrive = false; };
      brightness = { brightnessStep = 5; enforceMinimum = true; };

      # Fonte única de night light: o do noctalia. O wlsunset
      # (appearance/nightlight.nix) não é importado — evita duplicação.
      nightLight = {
        enabled      = true;
        autoSchedule = true;
        nightTemp    = "1800";
        dayTemp      = "6500";
      };
    };
  };

  # Serviço systemd em vez de spawn-at-startup: garante que WAYLAND_DISPLAY
  # já está no bus antes do noctalia conectar (status=203/EXEC sem caminho absoluto).
  # Depende de mango-session.target (que BindsTo=graphical-session.target):
  # o autostart_sh do mango dispara `systemctl --user start mango-session.target`
  # quando a sessão sobe — foi isso que tava faltando pra barra aparecer.
  systemd.user.services.noctalia-shell = {
    Unit = {
      Description = "Noctalia Shell — bar, notifications, wallpaper, lock, idle";
      After       = [ "mango-session.target" ];
      PartOf      = [ "mango-session.target" ];
    };
    Service = {
      # Caminho absoluto obrigatório: systemd user não herda o PATH do shell.
      ExecStart  = "${inputs.noctalia.packages.${pkgs.system}.default}/bin/noctalia-shell";
      Restart    = "on-failure";
      RestartSec = "3s";
    };
    Install.WantedBy = [ "mango-session.target" ];
  };

  # ── LOCK ANTES DE SUSPENDER (inibidor de verdade) ───────────────────────────
  # O "lockOnSuspend = true" do noctalia acima dispara o lock de forma
  # assíncrona, sem segurar o suspend. Como o kernel congela os processos
  # userspace logo em seguida, às vezes a tela de lock não tem tempo de montar
  # antes do freeze — resultado: acorda sem ter travado nada.
  #
  # Esse serviço usa um inibidor real do systemd-logind (systemd-inhibit
  # --what=sleep): ele SEGURA o suspend, manda travar a tela via IPC do
  # noctalia, espera a tela realmente confirmar que está montada, e só então
  # libera o inibidor pra suspend continuar. Suspend só acontece depois que a
  # tela já está travada e assentada — nunca mais na corrida.
  systemd.user.services.lock-before-suspend = {
    Unit = {
      Description = "Trava a tela e segura o suspend até o lock estar pronto";
      After        = [ "noctalia-shell.service" ];
      PartOf       = [ "mango-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = pkgs.writeShellScript "lock-before-suspend" ''
        set -u
        NOCTALIA="${inputs.noctalia.packages.${pkgs.system}.default}/bin/noctalia-shell"

        ${pkgs.systemd}/bin/systemd-inhibit \
          --what=sleep \
          --who="lock-before-suspend" \
          --why="Travar tela antes de suspender" \
          --mode=delay \
          ${pkgs.bash}/bin/bash -c '
            # Escuta o sinal PrepareForSleep(true) do logind via busctl.
            ${pkgs.systemd}/bin/busctl monitor --system \
              --match="type=signal,interface=org.freedesktop.login1.Manager,member=PrepareForSleep" \
              | while IFS= read -r line; do
                  case "$line" in
                    *BOOLEAN\ true*)
                      # Manda travar e espera a tela confirmar (evita corrida).
                      '"$NOCTALIA"' ipc call lockScreen lock
                      for i in $(seq 1 20); do
                        locked=$('"$NOCTALIA"' ipc call lockScreen isLocked 2>/dev/null || echo false)
                        [ "$locked" = "true" ] && break
                        sleep 0.1
                      done
                      # Descarta qualquer evento de teclado acumulado até aqui
                      # antes de deixar o suspend prosseguir de fato.
                      sleep 0.3
                      exit 0
                      ;;
                  esac
                done
          '
      '';
      Restart    = "always";
      RestartSec = "1s";
    };
    Install.WantedBy = [ "mango-session.target" ];
  };
}
