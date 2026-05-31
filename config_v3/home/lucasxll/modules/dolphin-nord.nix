# home/lucasxll/modules/dolphin-nord.nix
#
# Tema Nord para Dolphin e todos os apps Qt/KDE
# - Kvantum com tema Nordic (cores Nord)
# - Ícones Papirus-Dark
# - Fonte Inter para UI
# - Transparência via picom (configurado em picom.nix)

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nordic                              # tema Nord para Kvantum + GTK
    papirus-icon-theme                  # ícones Papirus-Dark
    inter                               # fonte UI limpa e moderna
    libsForQt5.qtstyleplugin-kvantum   # motor de temas Qt
    libsForQt5.qt5ct                   # configurador Qt5
  ];

  # Qt usa Kvantum como motor de temas
  qt = {
    enable = true;
    platformTheme.name = "kvantum";
  };

  # Kvantum: seleciona o tema Nordic
  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=Nordic
  '';

  # Linka o tema Nordic para a pasta do Kvantum
  xdg.configFile."Kvantum/Nordic".source =
    "${pkgs.nordic}/share/Kvantum/Nordic";

  # KDE Globals — afeta Dolphin, Ark, e todos os apps KDE/Qt
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

  # Dolphin config específico
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

  # GTK também fica Nord (para apps GTK que abrem dentro do Dolphin)
  gtk = {
    enable = true;
    theme = {
      name    = "Nordic";
      package = pkgs.nordic;
    };
    iconTheme = {
      name    = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name    = "Inter";
      size    = 10;
      package = pkgs.inter;
    };
  };
}
