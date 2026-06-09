# modules/nixos/software/niri.nix
# Niri via niri-flake + xwayland-satellite.
#
# Fix niri 25.08: o postInstall original executa '$out/bin/niri completions bash'
# para gerar shell completions. O niri tenta inicializar como compositor
# (seat/libinput) e crasha no sandbox do Nix com exit 2.
# Solução: overrideAttrs removendo as completions e o output 'doc'.
#
# Fix autologin: o niri-flake pode registar pkgs.niri (não-overridado) em
# sessionPackages, resultando num desktops buildEnv sem niri.desktop.
# Solução: forçar sessionPackages a usar o mesmo niriPkg overridado.
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
  programs.niri = {
    enable  = true;
    package = niriPkg;
  };

  # Garante que o desktops buildEnv do SDDM tenha o niri.desktop correto.
  # O niri-flake pode registrar pkgs.niri (sem override) em sessionPackages;
  # mkAfter adiciona o niriPkg correto no final — o buildEnv com
  # ignoreCollisions irá usar o niri.desktop deste pacote.
  services.displayManager.sessionPackages = lib.mkAfter [ niriPkg ];

  environment.systemPackages                   = [ pkgs.xwayland-satellite ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  xdg.portal.extraPortals                      = [ pkgs.xdg-desktop-portal-wlr ];
}
