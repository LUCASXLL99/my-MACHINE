# modules/nixos/software/no-keyring.nix
#
# Remove dependência de KWallet/gnome-keyring.
# Consequência: sem criptografia de senhas salvas no browser.

{ pkgs, ... }:

{
  environment.etc."xdg/kwalletrc".text = ''
    [Wallet]
    Enabled=false
    First Use=false
  '';

  environment.sessionVariables.ELECTRON_PASSWORD_STORE = "basic";

  environment.etc."vivaldi/vivaldi-flags.conf".text = ''
    --password-store=basic
    --no-default-browser-check
  '';
}
