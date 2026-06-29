{ pkgs, ... }:

let
  niriPkg = pkgs.niri.overrideAttrs (old: {
    postInstall = builtins.replaceStrings
      [ "niri completions bash" "niri completions zsh" "niri completions fish" ]
      [ "true"                  "true"                 "true"                  ]
      old.postInstall;
  });
in
{
  programs.niri = { enable = true; package = niriPkg; };

  environment.systemPackages                  = [ pkgs.xwayland-satellite ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
