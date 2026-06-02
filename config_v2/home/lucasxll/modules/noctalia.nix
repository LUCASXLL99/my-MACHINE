# home/lucasxll/modules/noctalia.nix
# Noctalia Shell — barra, launcher, notificações, lock, idle.
# Binários via cache noctalia.cachix.org.

{ pkgs, inputs, lib, ... }:

{
  programs.noctalia-shell = {
    enable = true;

    colors = {
      mSurface            = "#1a1b26";
      mSurfaceVariant     = "#24283b";
      mHover              = "#292e42";
      mOnHover            = "#c0caf5";
      mPrimary            = "#7aa2f7";
      mOnPrimary          = "#1a1b26";
      mSecondary          = "#9aa5ce";
      mOnSecondary        = "#1a1b26";
      mTertiary           = "#bb9af7";
      mOnTertiary         = "#1a1b26";
      mOnSurface          = "#c0caf5";
      mOnSurfaceVariant   = "#9aa5ce";
      mOutline            = "#3d4466";
      mError              = "#f7768e";
      mOnError            = "#1a1b26";
      mShadow             = "#000000";
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
        weatherEnabled  = false;  # desativado para não precisar de API key
      };

      colorSchemes = {
        predefinedScheme  = "custom";
        useWallpaperColors = false;
        darkMode          = true;
        schedulingMode    = "off";
      };

      wallpaper = {
        enabled                   = false;   # false → mpvpaper gerencia via systemd
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
        enabled                  = true;
        location                 = "top_left";
        lowUrgencyDuration       = 4;
        normalUrgencyDuration    = 8;
        criticalUrgencyDuration  = 0;
        respectExpireTimeout     = false;
        sounds.enabled           = false;
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

      audio = {
        volumeStep      = 5;
        volumeOverdrive = false;
      };

      brightness = {
        brightnessStep = 5;
        enforceMinimum = true;
      };

      # luz noturna nativa — sem wlsunset, sem redshift, sem race condition
      nightLight = {
        enabled      = true;
        autoSchedule = true;
        nightTemp    = "3500";
        dayTemp      = "6500";
      };
    };
  };

}
