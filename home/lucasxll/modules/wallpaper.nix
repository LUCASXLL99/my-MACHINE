# home/lucasxll/modules/wallpaper.nix

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
      # "on-failure" em vez de "always": evita loop infinito se o arquivo
      # de wallpaper não existir ou o mpvpaper falhar repetidamente.
      # "always" pode causar restart storm que compete com o niri por recursos
      # e em casos extremos derruba a graphical-session.target.
      Restart               = "on-failure";
      RestartSec            = "5s";
      StartLimitIntervalSec = "60";
      StartLimitBurst       = "3";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
