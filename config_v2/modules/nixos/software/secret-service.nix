# modules/nixos/software/secret-service.nix
# gnome-keyring como Secret Service daemon — ativar em default.nix se necessário.
#
# ATENÇÃO: security.pam.services.sddm.enableGnomeKeyring = true pode
# travar o fluxo de autologin do SDDM. Manter false enquanto autologin estiver ativo.

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

  environment.systemPackages = with pkgs; [
    gnome-keyring
    libsecret
    keepassxc
    seahorse
  ];
}
