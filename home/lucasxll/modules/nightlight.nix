# home/lucasxll/modules/nightlight.nix
#
# Luz noturna híbrida: funciona em X11 (BSPWM) e Wayland (Niri).
#
# ┌─────────────┬────────────────────────────────────────────────┐
# │ Sessão      │ Ferramenta                                     │
# ├─────────────┼────────────────────────────────────────────────┤
# │ Niri/Wayland│ wlsunset  — daemon Wayland nativo, wlroots    │
# │ BSPWM/X11   │ redshift  — method=vidmode (estável no X11)   │
# └─────────────┴────────────────────────────────────────────────┘
#
# Os serviços usam ConditionEnvironment para se excluírem mutuamente:
# wlsunset só ativa se WAYLAND_DISPLAY existir.
# redshift  só ativa se WAYLAND_DISPLAY NÃO existir.
#
# Temperatura noturna: 1000 K   (agressiva, como estava no gammastep)
# Temperatura diurna:  6500 K
# Brilho noturno:      0.8
# Horários:            calculados pela localização (wlsunset)
#                      ou via -O flag para redshift se preferir fixo
#
# Localização padrão: Fortaleza, CE  (-3.7 / -38.5)
# Ajuste lat/lon abaixo se necessário.

{ pkgs, ... }:

let
  lat = "-3.7";
  lon = "-38.5";
in
{
  home.packages = with pkgs; [
    wlsunset  # Wayland
  ];

  # ══════════════════════════════════════════════════════════════
  # WAYLAND — wlsunset
  # Calcula dawn/dusk automaticamente pela latitude/longitude.
  # -t = temperatura noturna (K)   -T = temperatura diurna (K)
  # ══════════════════════════════════════════════════════════════
  # NÃO usar ConditionEnvironment=WAYLAND_DISPLAY: essa condição é avaliada
  # quando graphical-session.target sobe — antes do niri exportar WAYLAND_DISPLAY
  # ao bus. Resultado idêntico ao bug do xwayland-satellite: serviço skipado
  # silenciosamente, luz noturna nunca ativa.
  #
  # Fix: After+BindsTo=niri.service, igual ao padrão do xwayland-satellite.
  # O ExecStartPre confirma que WAYLAND_DISPLAY está disponível antes de iniciar.
  # ══════════════════════════════════════════════════════════════
  systemd.user.services.wlsunset = {
    Unit = {
      Description = "Night light — Wayland (wlsunset)";
      Documentation = "https://sr.ht/~kennylevinsen/wlsunset";
      After   = [ "niri.service" ];
      BindsTo = [ "niri.service" ];
    };
    Service = {
      Type = "simple";
      # Aguarda WAYLAND_DISPLAY estar no ambiente do systemd antes de iniciar.
      # Niri já está ativo nesse ponto (After=niri.service), então o loop
      # normalmente termina na primeira ou segunda iteração.
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
