# Live wallpaper via mpvpaper (wallpaper.mp4).
#
# DESATIVADO: o wallpaper do Noctalia (noctalia.nix) agora faz rotação
# automática dos wallpapers 4K em ~/Pictures/wallpapers — ter os dois
# rodando fazia um desenhar por cima do outro. O vídeo continua disponível
# manualmente via bind SUPER+Semicolon (pkill mpvpaper || mpvpaper ...).
#
# Se quiser voltar o vídeo como padrão: reative este serviço e desligue o
# bloco wallpaper do noctalia.nix.

{ config, pkgs, ... }:

let
  wallpaperPath = "${config.home.homeDirectory}/Pictures/wallpapers/wallpaper.mp4";

  launchScript = pkgs.writeShellScript "mpvpaper-launch" ''
    # Sem wallpaper: exit 0 evita restart loop e tela preta (StartLimitBurst)
    if [ ! -f "${wallpaperPath}" ]; then
      echo "mpvpaper: wallpaper não encontrado em ${wallpaperPath}" >&2
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
    [ -z "$WAYLAND_DISPLAY" ] && { echo "mpvpaper: WAYLAND_DISPLAY não disponível" >&2; exit 1; }
    exec ${pkgs.mpvpaper}/bin/mpvpaper -o 'no-audio loop' '*' ${wallpaperPath}
  '';
in
{
  home.packages = [ pkgs.mpvpaper ];

  systemd.user.services.mpvpaper = {
    Unit = {
      Description = "mpvpaper — live wallpaper Wayland (desativado: noctalia cuida)";
      After  = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
      # Não sobe com a sessão — o Noctalia faz rotação dos estáticos.
      ConditionPathExists = "/nonexistent";
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
