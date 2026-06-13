# modules/nixos/software/secret-service.nix
# DESATIVADO — não importado em hosts/nixos/default.nix.
# gnome-keyring como Secret Service daemon (alternativa ao KWallet).
#
# ATENÇÃO: security.pam.services.sddm.enableGnomeKeyring = true pode
# travar o autologin do SDDM. Manter false enquanto autologin estiver ativo.
#
# Para ativar: adicionar o import em hosts/nixos/default.nix e remover
# modules/nixos/software/no-keyring.nix (conflito de kwalletrc).

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
