{ pkgs, ... }:

# Tema Qt agora é gerenciado pelo Stylix (ver appearance/stylix.nix): ele
# gera o ~/.config/qt6ct/qt6ct.conf (e qt5ct) com o esquema Tokyo Night e
# o estilo kvantum, e define o platform theme do home-manager. Aqui só
# garantimos que os pacotes necessários existem no sistema.
#
# Removido: QT_QPA_PLATFORMTHEME=qt6ct e os qt6ct/qt5ct.conf manuais com
# BreezeDark — eram a fonte do conflito de tema (home dizia kvantum/Nordic,
# sistema dizia qt6ct/BreezeDark). O config do home (~/.config) tem
# precedência sobre /etc/xdg, então o Stylix manda.

{
  environment.systemPackages = with pkgs; [
    kdePackages.qt6ct
    libsForQt5.qt5ct
    kdePackages.breeze
    kdePackages.breeze-icons
  ];
}
