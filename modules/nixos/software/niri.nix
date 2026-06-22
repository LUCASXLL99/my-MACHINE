# Fix niri 25.08: postInstall roda 'niri completions bash' que tenta inicializar
# como compositor e crasha no sandbox do Nix — override remove esse step.
#
# environment.pathsToLink + environment.etc: sessionPackages sozinho não garante
# merge de /share/wayland-sessions quando services.xserver.enable = true coloca
# o SDDM em modo X11. pathsToLink força o merge; environment.etc é fallback
# explícito para o SDDM em modo Wayland.

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

  environment.pathsToLink = [ "/share/wayland-sessions" ];
  environment.etc."wayland-sessions/niri.desktop".source =
    "${niriPkg}/share/wayland-sessions/niri.desktop";
}
