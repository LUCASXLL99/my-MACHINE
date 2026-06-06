# modules/nixos/software/niri.nix
# Niri via niri-flake + xwayland-satellite.
# Binários via cache niri.cachix.org — sem compilação local.
# services.displayManager.sddm.wayland.enable é diferente (requer kwin).
#
# NOTA: o postInstall do niri 25.08 executa '$out/bin/niri completions bash'
# para gerar shell completions, mas o niri tenta inicializar como compositor
# (seat/libinput) e crasha no sandbox do Nix com exit 2.
# Solução: overrideAttrs removendo a geração de completions do postInstall.
{ pkgs, inputs, ... }:
{
  programs.niri = {
    enable  = true;
    package = inputs.niri.packages.${pkgs.system}.niri.overrideAttrs (_: {
      postInstall = ''
        install -Dm0755 resources/niri-session -t $out/bin
        install -Dm0644 resources/niri.desktop -t $out/share/wayland-sessions
        install -Dm0644 resources/niri-portals.conf -t $out/share/xdg-desktop-portal
        install -Dm0644 resources/niri{-shutdown.target,.service} -t $out/lib/systemd/user
      '';
    });
  };

  environment.systemPackages        = [ pkgs.xwayland-satellite ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
}
