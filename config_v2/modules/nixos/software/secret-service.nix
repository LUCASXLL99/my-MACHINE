# sddm.enableGnomeKeyring = false: autologin pode travar se ativado.

{ pkgs, ... }:

{
  environment.etc."xdg/kwalletrc".text = ''
    [Wallet]
    Enabled=false
    First Use=false
  '';

  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.sddm.enableGnomeKeyring  = false;

  services.gnome.gnome-keyring.enable = true;

  environment.systemPackages = with pkgs; [ gnome-keyring libsecret keepassxc seahorse ];
}
