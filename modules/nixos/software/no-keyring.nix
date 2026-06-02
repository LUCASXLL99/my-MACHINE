# modules/nixos/software/no-keyring.nix
# Desativa KWallet. ELECTRON_PASSWORD_STORE fica aqui (fonte única).

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
