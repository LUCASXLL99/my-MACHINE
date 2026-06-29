{ config, pkgs, ... }:

let
  wallpaperPath = "${config.home.homeDirectory}/Pictures/wallpapers/wallpaper.mp4";

  launchScript = pkgs.writeShellScript "mpvpaper-launch" ''
    # Aborta silenciosamente (exit 0 = sem restart) se o arquivo não existir.
    # Sem esse guard, o mpvpaper falha 3 vezes (StartLimitBurst), renderizando
    # um frame preto a cada tentativa — o que resulta em tela preta mesmo com
    # o niri rodando normalmente.
    if [ ! -f "${wallpaperPath}" ]; then
      echo "mpvpaper-launch: wallpaper não encontrado em ${wallpaperPath}, abortando sem restart." >&2
      exit 0
    fi
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
      Restart               = "on-failure";
      RestartSec            = "5s";
      StartLimitIntervalSec = "60";
      StartLimitBurst       = "3";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
