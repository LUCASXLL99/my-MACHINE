{ pkgs, ... }:

let
  # pkgs.niri-unstable vem do overlay niri.overlays.niri (ver flake.nix).
  # Por quê -unstable e não -stable: niri-stable neste flake é a 25.08, e a
  # sintaxe "gestures { hot-corners { top-right } }" só existe desde a 25.11
  # — pkgs.niri puro (nixpkgs nixos-25.05) também é antigo demais pra isso.
  # -unstable é o HEAD do branch main do niri, atualizado e testado pelo
  # niri-flake antes de ir pro cache em niri.cachix.org.
  niriPkg = pkgs.niri-unstable.overrideAttrs (old: {
    postInstall = builtins.replaceStrings
      [ "niri completions bash" "niri completions zsh" "niri completions fish" ]
      [ "true"                  "true"                 "true"                  ]
      (old.postInstall or "");
  });
in
{
  programs.niri = { enable = true; package = niriPkg; };

  environment.systemPackages                  = [ pkgs.xwayland-satellite ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
