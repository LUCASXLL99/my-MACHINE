# nixos-Modules/Modules-Software/secret-service.nix
#
# Daemon de senhas universal — agnóstico de DE/WM.
#
# Resolve o problema de apps como Vivaldi, Obsidian, VSCode, Slack e
# qualquer outro que use a Secret Service API (D-Bus) para guardar
# credenciais. Sem isso, esses apps perdem senhas/sessões ao sair do KDE.
#
# Usa apenas o daemon do gnome-keyring — sem dependências de GNOME.
# O nome é enganoso: é uma biblioteca de sistema, não parte do DE.
#
# Apps beneficiados automaticamente (sem configuração extra):
#   - Vivaldi, Chrome, Chromium (baseados em Electron/Chromium)
#   - Obsidian, VSCode, Cursor, e qualquer app Electron
#   - NetworkManager (senhas Wi-Fi por usuário)
#   - SSH Agent integrado
#   - Qualquer app que use libsecret
#
# ATIVAR:    descomentar o import no configuration.nix + rebuild
# DESATIVAR: comentar o import no configuration.nix + rebuild

{ pkgs, ... }:

{
  # Desativa KWallet — conflita com gnome-keyring
  environment.etc."xdg/kwalletrc".text = ''
    [Wallet]
    Enabled=false
    First Use=false
  '';

  # Desbloqueia o keyring automaticamente no login via PAM
  security.pam.services.login.enableGnomeKeyring  = true;
  security.pam.services.sddm.enableGnomeKeyring   = true;

  services.gnome.gnome-keyring.enable = true;

  environment.systemPackages = with pkgs; [
    gnome-keyring   # daemon Secret Service
    libsecret       # biblioteca usada pelos apps para acessar o keyring
    keepassxc       # gerenciador de senhas com UI (também implementa Secret Service)
    seahorse        # GUI para inspecionar/gerenciar o keyring (opcional)
  ];
}
