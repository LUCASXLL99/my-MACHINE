# Luz noturna via wlsunset — Fortaleza, CE (-3.7 / -38.5).
# After+BindsTo=niri.service + ExecStartPre aguarda WAYLAND_DISPLAY
# (ConditionEnvironment é avaliado antes do niri exportar ao bus).

{ pkgs, ... }:

let
  lat = "-3.7";
  lon = "-38.5";
in
{
  home.packages = [ pkgs.wlsunset ];

  systemd.user.services.wlsunset = {
    Unit = {
      Description = "Night light — wlsunset";
      After   = [ "niri.service" ];
      BindsTo = [ "niri.service" ];
    };
    Service = {
      Type = "simple";
      ExecStartPre = pkgs.writeShellScript "wait-wayland-wlsunset" ''
        for i in $(seq 1 20); do
          WD=$(${pkgs.systemd}/bin/systemctl --user show-environment 2>/dev/null \
               | grep '^WAYLAND_DISPLAY=' | cut -d= -f2)
          if [ -n "$WD" ]; then export WAYLAND_DISPLAY="$WD"; exit 0; fi
          sleep 0.5
        done
        echo "wlsunset: WAYLAND_DISPLAY não disponível em 10s" >&2
        exit 1
      '';
      ExecStart  = "${pkgs.wlsunset}/bin/wlsunset -l ${lat} -L ${lon} -t 2500 -T 6500 -g 0.8";
      Restart    = "on-failure";
      RestartSec = "5s";
    };
    Install.WantedBy = [ "niri.service" ];
  };
}
