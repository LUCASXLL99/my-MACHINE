# modules/nixos/software/secret-service.nix
# Daemon de senhas via gnome-keyring (sem dependências GNOME).
# Beneficia Vivaldi, Chrome, Obsidian, VSCode, NetworkManager e qualquer app libsecret.
#
# ATIVAR/DESATIVAR: (des)comentar o import no configuration.nix + rebuild

{ pkgs, ... }:

{
  # Desativa KWallet — conflita com gnome-keyring
  environment.etc."xdg/kwalletrc".text = ''
    [Wallet]
    Enabled=false
    First Use=false
  '';

  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.sddm.enableGnomeKeyring  = true;

  services.gnome.gnome-keyring.enable = true;

  environment.systemPackages = with pkgs; [
    gnome-keyring
    libsecret
    keepassxc
    seahorse   # GUI para inspecionar o keyring (opcional)
  ];
}
