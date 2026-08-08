{ pkgs, ... }:

# Sem sessão Plasma completa (mango é standalone), nenhum serviço aplica
# tema Qt automaticamente — apps KDE (Dolphin, Ark) caem no estilo Qt
# padrão (Fusion claro), ignorando o resto do desktop escuro.
#
# qt6ct/qt5ct + QT_QPA_PLATFORMTHEME resolvem isso: fazem qualquer app
# Qt (5 ou 6) ler um estilo e paleta configurados aqui, fora do Plasma.
# Usamos o esquema BreezeDark (do kdePackages.breeze, já é dependência
# indireta do Dolphin) pra combinar com os outros apps KDE.

{
  environment.systemPackages = with pkgs; [
    kdePackages.qt6ct
    libsForQt5.qt5ct
    kdePackages.breeze
    kdePackages.breeze-icons
  ];

  environment.sessionVariables.QT_QPA_PLATFORMTHEME = "qt6ct";

  environment.etc."xdg/qt6ct/qt6ct.conf".text = ''
    [Appearance]
    style=Breeze
    color_scheme_path=${pkgs.kdePackages.breeze}/share/color-schemes/BreezeDark.colors
    icon_theme=breeze-dark

    [Interface]
    stylesheets=
  '';

  environment.etc."xdg/qt5ct/qt5ct.conf".text = ''
    [Appearance]
    style=Breeze
    color_scheme_path=${pkgs.kdePackages.breeze}/share/color-schemes/BreezeDark.colors
    icon_theme=breeze-dark

    [Interface]
    stylesheets=
  '';
}
