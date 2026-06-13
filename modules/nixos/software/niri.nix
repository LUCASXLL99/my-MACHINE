# modules/nixos/software/niri.nix
# Niri via niri-flake + xwayland-satellite.
#
# Override necessário: o postInstall original executa 'niri completions bash'
# dentro do sandbox Nix (sem seat/libinput) → exit 2. Solução: remover o
# passo de completions e o output 'doc', instalar só os arquivos essenciais.
#
# sessionPackages com mkBefore: garante que o niri.desktop do niriPkg
# (overridado) vença colisões no buildEnv do SDDM sobre o pkgs.niri original
# que o niri-flake possa registrar.
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

  services.displayManager.sessionPackages = lib.mkBefore [ niriPkg ];

  environment.systemPackages                   = [ pkgs.xwayland-satellite ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  # Portais XDG declarados em default.nix (xdg.portal) para manter tudo junto.
}
