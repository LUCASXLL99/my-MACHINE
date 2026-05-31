# modules/nixos/software/secret-service.nix
#
# gnome-keyring como daemon Secret Service — agnóstico de DE/WM.
# Resolve perda de credenciais em Vivaldi, Obsidian, VSCode, etc.
# após sair de sessões não-KDE.
#
# ATIVAR: descomentar o import no default.nix + rebuild

{ pkgs, ... }:

{
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
    seahorse    # GUI para inspecionar o keyring (opcional)
  ];
}
