# Fix niri 25.08: postInstall executa 'niri completions bash' que tenta
# inicializar como compositor e crasha no sandbox do Nix.
# Fix autologin: força sessionPackages a usar o niriPkg overridado com niri.desktop correto.
#
# environment.pathsToLink + environment.etc:
#   sessionPackages por si só não garante que o path seja linkado quando
#   services.xserver.enable = true coloca o SDDM em modo X11.
#   A linha pathsToLink força o merge de /share/wayland-sessions no closure
#   do sistema. O environment.etc é uma ancora extra: expõe o niri.desktop
#   diretamente em /etc/wayland-sessions/ para que o SDDM em modo Wayland
#   também o encontre via XDG_DATA_DIRS.

{ pkgs, lib, ... }:

let
  niriPkg = pkgs.niri.overrideAttrs (_: {
    outputs = [ "out" ];
    postInstall = ''
      install -Dm0755 resources/niri-session -t $out/bin
      install -Dm0644 resources/niri.desktop -t $out/share/wayland-sessions
      install -Dm0644 resources/niri-portals.conf -t $out/share/xdg-desktop-portal
      install -Dm0644 resources/niri{-shutdown.target,.service} -t $out/lib/systemd/user
    '';
  });
in
{
  programs.niri = { enable = true; package = niriPkg; };

  services.displayManager.sessionPackages    = lib.mkBefore [ niriPkg ];
  environment.systemPackages                 = [ pkgs.xwayland-satellite ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Garante que /share/wayland-sessions seja mergeado no path do sistema.
  # Sem isso, o SDDM em modo Wayland não encontra o niri.desktop mesmo que
  # sessionPackages esteja correto.
  environment.pathsToLink = [ "/share/wayland-sessions" ];

  # Âncora explícita: copia o niri.desktop para /etc/wayland-sessions/
  # como fallback caso XDG_DATA_DIRS não inclua o store path do niriPkg.
  environment.etc."wayland-sessions/niri.desktop".source =
    "${niriPkg}/share/wayland-sessions/niri.desktop";
}
