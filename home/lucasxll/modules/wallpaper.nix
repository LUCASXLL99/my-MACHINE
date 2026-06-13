# home/lucasxll/modules/wallpaper.nix
# mpvpaper como wallpaper animado (Wayland). Gerenciado via systemd user.
# O pacote também é declarado em wallcards.nix (system) para o plugin Wallcards
# do noctalia — a duplicata é intencional (contextos diferentes).

{ config, pkgs, ... }:

let
  wallpaperPath = "${config.home.homeDirectory}/Pictures/wallpapers/wallpaper.mp4";

  launchScript = pkgs.writeShellScript "mpvpaper-launch" ''
    if [ -z "$WAYLAND_DISPLAY" ]; then
      XDG_RUNTIME_DIR="${''}${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
      for _i in $(seq 1 30); do
        for _f in "$XDG_RUNTIME_DIR"/wayland-?; do
          [ -S "$_f" ] || continue
          export WAYLAND_DISPLAY="$(basename "$_f")"
          break 2
        done
        sleep 0.5
      done
    fi

    [ -z "$WAYLAND_DISPLAY" ] && {
      echo "mpvpaper-launch: WAYLAND_DISPLAY não disponível" >&2; exit 1
    }

    exec ${pkgs.mpvpaper}/bin/mpvpaper -o 'no-audio loop' '*' ${wallpaperPath}
  '';
in
{
  systemd.user.services.mpvpaper = {
    Unit = {
      Description = "mpvpaper — live wallpaper Wayland";
      After  = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart             = "${launchScript}";
      Restart               = "on-failure";
      RestartSec            = "5s";
      StartLimitIntervalSec = "60";
      StartLimitBurst       = "3";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
