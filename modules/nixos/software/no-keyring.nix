# modules/nixos/software/no-keyring.nix
#
# Remove dependência de qualquer serviço de senhas (KWallet, gnome-keyring).
# Consequência aceita: sem criptografia de senhas salvas no browser.
# Benefício: funciona igual em KDE, bspwm, qualquer ambiente.

{ pkgs, ... }:

{
  # Desativa KWallet
  environment.etc."xdg/kwalletrc".text = ''
    [Wallet]
    Enabled=false
    First Use=false
  '';

  # Variável global para apps Electron (Obsidian, VSCode, etc.)
  environment.sessionVariables = {
    ELECTRON_PASSWORD_STORE = "basic";
  };

  # Flag do Vivaldi via arquivo de configuração que ele lê automaticamente
  # Localização correta no Linux: /etc/vivaldi/vivaldi-flags.conf
  environment.etc."vivaldi/vivaldi-flags.conf".text = ''
    --password-store=basic
    --no-default-browser-check
  '';
}
