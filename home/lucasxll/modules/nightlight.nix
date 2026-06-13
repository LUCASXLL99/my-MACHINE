# home/lucasxll/modules/nightlight.nix
# DESATIVADO — não importado em default.nix.
# O noctalia-shell gerencia luz noturna nativamente (nightLight em noctalia.nix).
# Manter aqui como fallback caso o noctalia seja removido.
#
# Para reativar: adicionar ./modules/nightlight.nix em home/lucasxll/default.nix
# e desativar noctalia.settings.nightLight.enabled.

{ pkgs, ... }:

let
  lat = "-3.7";   # Fortaleza, CE
  lon = "-38.5";
in
{
  home.packages = [ pkgs.wlsunset ];

  systemd.user.services.wlsunset = {
    Unit = {
      Description = "Night light — wlsunset (Wayland)";
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
        echo "wlsunset: WAYLAND_DISPLAY nao disponivel" >&2
        exit 1
      '';
      ExecStart  = "${pkgs.wlsunset}/bin/wlsunset -l ${lat} -L ${lon} -t 2500 -T 6500 -g 0.8";
      Restart    = "on-failure";
      RestartSec = "5s";
    };
    Install.WantedBy = [ "niri.service" ];
  };
}
