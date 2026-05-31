# modules/nixos/hardware/sddm-reflect.nix — SDDM Qt6 com sddm-astronaut-theme
#
# SDDM 0.21 usa Qt6 (kdePackages.sddm). kdePackages.qtmultimedia deve ser
# passado explicitamente — não é puxado como dep automática (bug nixpkgs #390251).
#
# Temas: "astronaut" (padrão), "black_hole", "jake_the_dog",
#        "japanese_aesthetic", "post_apocalipse", "pixel_sakura"
#
# Preview sem reiniciar:
#   sudo -u sddm sddm-greeter-qt6 --test-mode \
#     --theme /run/current-system/sw/share/sddm/themes/sddm-astronaut-theme

{ pkgs, ... }:

let
  sddm-astronaut = pkgs.sddm-astronaut.override {
    # embeddedTheme = "black_hole";  # descomente para trocar variante

    themeConfig = {
      # Paleta Tokyo Night Dark (consistente com stylix.base16Scheme)
      AccentColor     = "#7aa2f7";   # base0D
      BackgroundColor = "#1a1b26";   # base00
      MainColor       = "#c0caf5";   # base05
      FormPosition    = "center";
      # Background = toString /home/lucasxll/Pictures/wallpapers/sddm.png;
    };
  };
in
{
  environment.systemPackages = [ sddm-astronaut ];

  services.displayManager.sddm = {
    enable  = true;
    package = pkgs.kdePackages.sddm;  # forçar Qt6
    theme   = "sddm-astronaut-theme";
    extraPackages = [
      sddm-astronaut
      pkgs.kdePackages.qtmultimedia  # necessário — bug nixpkgs #390251
    ];
    wayland.enable = true;  # compositor Wayland interno do SDDM 0.21
    settings = {
      General = {
        RememberLastUser    = false;
        RememberLastSession = false;
      };
      Users.RememberLastUser = false;
    };
  };
}
