# Restart="always": cobre SIGTERM (noctalia mata o processo na subida).

{ config, pkgs, ... }:

let
  wallpaperPath = "${config.home.homeDirectory}/Pictures/wallpapers/wallpaper.mp4";

  launchScript = pkgs.writeShellScript "mpvpaper-launch" ''
    if [ -z "$WAYLAND_DISPLAY" ]; then
      XDG_RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
      for _i in $(seq 1 30); do
        for _f in "$XDG_RUNTIME_DIR"/wayland-?; do
          [ -S "$_f" ] || continue
          export WAYLAND_DISPLAY="$(basename "$_f")"
          break 2
        done
        sleep 0.5
      done
    fi

    if [ -z "$WAYLAND_DISPLAY" ]; then
      echo "mpvpaper-launch: WAYLAND_DISPLAY não disponível" >&2
      exit 1
    fi

    exec ${pkgs.mpvpaper}/bin/mpvpaper -o 'no-audio loop' '*' ${wallpaperPath}
  '';
in
{
  home.packages = [ pkgs.mpvpaper ];

  systemd.user.services.mpvpaper = {
    Unit = {
      Description = "mpvpaper — live wallpaper Wayland";
      After  = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart             = "${launchScript}";
      Restart               = "always";
      RestartSec            = "2s";
      StartLimitIntervalSec = "0";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
