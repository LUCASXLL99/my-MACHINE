# home/lucasxll/modules/nightlight.nix — luz noturna híbrida
#
# Wayland (niri): wlsunset  | X11 (bspwm): redshift
#
# Não usar ConditionEnvironment=WAYLAND_DISPLAY: avaliado antes do niri
# exportar WAYLAND_DISPLAY ao bus → serviço skipado silenciosamente.
# Fix: After+BindsTo=niri.service + ExecStartPre aguarda WAYLAND_DISPLAY.
#
# Localização: Fortaleza, CE  (-3.7 / -38.5)

{ pkgs, ... }:

let
  lat = "-3.7";
  lon = "-38.5";
in
{
  home.packages = with pkgs; [ wlsunset ];

  systemd.user.services.wlsunset = {
    Unit = {
      Description   = "Night light — Wayland (wlsunset)";
      Documentation = "https://sr.ht/~kennylevinsen/wlsunset";
      After   = [ "niri.service" ];
      BindsTo = [ "niri.service" ];
    };
    Service = {
      Type = "simple";
      ExecStartPre = pkgs.writeShellScript "wait-wayland-wlsunset" ''
        for i in $(seq 1 20); do
          WD=$(${pkgs.systemd}/bin/systemctl --user show-environment 2>/dev/null \
               | grep '^WAYLAND_DISPLAY=' | cut -d= -f2)
          if [ -n "$WD" ]; then
            export WAYLAND_DISPLAY="$WD"
            exit 0
          fi
          sleep 0.5
        done
        echo "wlsunset: WAYLAND_DISPLAY nao disponivel em 10s" >&2
        exit 1
      '';
      ExecStart = "${pkgs.wlsunset}/bin/wlsunset -l ${lat} -L ${lon} -t 2500 -T 6500 -g 0.8";
      Restart    = "on-failure";
      RestartSec = "5s";
    };
    Install.WantedBy = [ "niri.service" ];
  };
}
