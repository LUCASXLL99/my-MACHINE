# modules/nixos/software/niri.nix
# Niri via niri-flake + xwayland-satellite.
#
# Fix niri 25.08: o postInstall original executa '$out/bin/niri completions bash'
# para gerar shell completions. O niri tenta inicializar como compositor
# (seat/libinput) e crasha no sandbox do Nix com exit 2.
# Solução: overrideAttrs removendo as completions e o output 'doc' (man pages)
# — funcionalidade não-essencial; tudo mais (session, portal, systemd) preservado.
{ pkgs, ... }:
{
  programs.niri = {
    enable  = true;
    package = pkgs.niri.overrideAttrs (_: {
      outputs = [ "out" ];
      postInstall = ''
        install -Dm0755 resources/niri-session -t $out/bin
        install -Dm0644 resources/niri.desktop -t $out/share/wayland-sessions
        install -Dm0644 resources/niri-portals.conf -t $out/share/xdg-desktop-portal
        install -Dm0644 resources/niri{-shutdown.target,.service} -t $out/lib/systemd/user
      '';
    });
  };

  environment.systemPackages                   = [ pkgs.xwayland-satellite ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  xdg.portal.extraPortals                      = [ pkgs.xdg-desktop-portal-wlr ];
}
