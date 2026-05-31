# modules/nixos/software/no-keyring.nix
# Remove dependência de KWallet/gnome-keyring.
# Trade-off: senhas do browser não ficam criptografadas em disco.

{ pkgs, ... }:

{
  environment.etc."xdg/kwalletrc".text = ''
    [Wallet]
    Enabled=false
    First Use=false
  '';

  environment.sessionVariables = {
    ELECTRON_PASSWORD_STORE = "basic";
  };

  environment.etc."vivaldi/vivaldi-flags.conf".text = ''
    --password-store=basic
    --no-default-browser-check
  '';
}
