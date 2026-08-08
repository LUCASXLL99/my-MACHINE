# Aparência Dolphin/Qt/KDE unificada em Tokyo Night.
# GTK e Qt (kvantum via qtct) agora são gerados pelo Stylix a partir do
# esquema Tokyo Night (ver stylix.nix) — aqui ficam só os ajustes
# específicos do Dolphin e do kdeglobals.
# tela-icon-theme: tema de ícones do repo mango-fedora (theblackdon),
# disponível como alternativa ao Papirus — o ativo continua Papirus-Dark.

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    papirus-icon-theme
    tela-icon-theme
    inter
    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtstyleplugin-kvantum
  ];

  xdg.configFile."kdeglobals".text = ''
    [Icons]
    Theme=Papirus-Dark

    [General]
    ColorScheme=TokyoNight
    Name=Tokyo Night
    shadeSortColumn=true
    font=Inter,10,-1,5,400,0,0,0,0,0
    fixed=JetBrainsMono Nerd Font,10,-1,5,400,0,0,0,0,0
    menuFont=Inter,10,-1,5,400,0,0,0,0,0
    smallestReadableFont=Inter,8,-1,5,400,0,0,0,0,0
    toolBarFont=Inter,9,-1,5,400,0,0,0,0,0

    [KDE]
    contrast=4
    widgetStyle=kvantum

    [Colors:Button]
    BackgroundNormal=36,40,59
    BackgroundAlternate=41,49,71
    ForegroundNormal=192,202,245

    [Colors:View]
    BackgroundNormal=26,27,38
    BackgroundAlternate=36,40,59
    ForegroundNormal=192,202,245
    ForegroundLink=122,162,247
    ForegroundVisited=187,154,247

    [Colors:Window]
    BackgroundNormal=36,40,59
    ForegroundNormal=192,202,245

    [Colors:Selection]
    BackgroundNormal=122,162,247
    ForegroundNormal=26,27,38

    [Colors:Tooltip]
    BackgroundNormal=41,49,71
    ForegroundNormal=192,202,245
  '';

  xdg.configFile."dolphinrc".text = ''
    [General]
    ShowFullPath=true
    ShowStatusBar=true
    ShowZoomSlider=true
    Version=202
    ViewPropsTimestamp=2024,1,1,0,0,0

    [IconsMode]
    IconSize=48
    PreviewSize=64

    [MainWindow]
    MenuBar=Disabled
    ToolBar=KToolBar,extraToolBar

    [PlacesPanel]
    IconSize=22
  '';
}
