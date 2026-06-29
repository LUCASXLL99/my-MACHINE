{ pkgs, inputs, lib, ... }:

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

      wallpaper = {
        enabled                   = false;
        directory                 = "/home/lucasxll/Pictures/wallpapers";
        automationEnabled         = false;
        wallpaperChangeMode       = "random";
        randomIntervalSec         = 300;
        transitionDuration        = 1500;
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

      nightLight = {
        enabled      = true;
        autoSchedule = true;
        nightTemp    = "3500";
        dayTemp      = "6500";
      };
    };
  };

  # Serviço systemd em vez de spawn-at-startup: garante que WAYLAND_DISPLAY
  # já está no bus antes do noctalia conectar (status=203/EXEC sem caminho absoluto).
  systemd.user.services.noctalia-shell = {
    Unit = {
      Description = "Noctalia Shell — bar, notifications, wallpaper, lock, idle";
      After       = [ "graphical-session.target" ];
      PartOf      = [ "graphical-session.target" ];
    };
    Service = {
      # Caminho absoluto obrigatório: systemd user não herda o PATH do shell.
      ExecStart  = "${inputs.noctalia.packages.${pkgs.system}.default}/bin/noctalia-shell";
      Restart    = "on-failure";
      RestartSec = "3s";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
