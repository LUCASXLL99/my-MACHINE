# Aparência Dolphin/Qt/KDE unificada em Nord.
# GTK e Qt (kvantum via qtct) agora são gerados pelo Stylix a partir do
# esquema Nord (ver stylix.nix) — aqui ficam só os ajustes
# específicos do Dolphin e do kdeglobals.

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
    ColorScheme=Nord
    Name=Nord
    shadeSortColumn=true
    font=Inter,11,-1,5,400,0,0,0,0,0
    fixed=JetBrainsMono Nerd Font,11,-1,5,400,0,0,0,0,0
    menuFont=Inter,11,-1,5,400,0,0,0,0,0
    smallestReadableFont=Inter,9,-1,5,400,0,0,0,0,0
    toolBarFont=Inter,10,-1,5,400,0,0,0,0,0

    [KDE]
    contrast=6
    widgetStyle=kvantum

    [Colors:Button]
    BackgroundNormal=69,78,98
    BackgroundAlternate=78,89,111
    ForegroundNormal=255,255,255

    [Colors:View]
    # Fundo mais claro ainda (acima do surface1) p/ máxima legibilidade.
    # Pedido: "aumente a claridade mais um pouco". Letras brancas puras.
    BackgroundNormal=92,104,128
    BackgroundAlternate=102,115,141
    ForegroundNormal=255,255,255
    ForegroundLink=255,255,255
    ForegroundVisited=255,255,255

    [Colors:Window]
    BackgroundNormal=56,64,78
    ForegroundNormal=255,255,255

    [Colors:Selection]
    BackgroundNormal=129,161,193
    ForegroundNormal=46,52,64

    [Colors:Tooltip]
    BackgroundNormal=92,104,128
    ForegroundNormal=255,255,255
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

    [Fonts]
    GeneralFont=Inter,12
    FixedFont=JetBrainsMono Nerd Font,12
  '';
}
