# gnome-keyring como Secret Service daemon.
# security.pam.services.sddm.enableGnomeKeyring = false enquanto autologin estiver ativo
# (pode travar o fluxo de autologin).

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
