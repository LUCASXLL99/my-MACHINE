# Tema Nord para Dolphin e apps Qt/KDE via Kvantum.

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nordic
    papirus-icon-theme
    inter
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct
  ];

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
  };

  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=Nordic
  '';

  xdg.configFile."Kvantum/Nordic".source =
    "${pkgs.nordic}/share/Kvantum/Nordic";

  xdg.configFile."kdeglobals".text = ''
    [Icons]
    Theme=Papirus-Dark

    [General]
    ColorScheme=NordColorScheme
    Name=Nordic
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
    BackgroundNormal=46,52,64
    ForegroundNormal=236,239,244

    [Colors:View]
    BackgroundNormal=39,43,53
    BackgroundAlternate=46,52,64
    ForegroundNormal=236,239,244
    ForegroundLink=136,192,208
    ForegroundVisited=180,142,173

    [Colors:Window]
    BackgroundNormal=46,52,64
    ForegroundNormal=236,239,244

    [Colors:Selection]
    BackgroundNormal=94,129,172
    ForegroundNormal=236,239,244

    [Colors:Tooltip]
    BackgroundNormal=59,66,82
    ForegroundNormal=236,239,244
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

  gtk = {
    enable = true;
    theme     = { name = "Nordic";       package = pkgs.nordic; };
    iconTheme = { name = "Papirus-Dark"; package = pkgs.papirus-icon-theme; };
    font      = { name = "Inter"; size = 10; package = pkgs.inter; };
  };
}
