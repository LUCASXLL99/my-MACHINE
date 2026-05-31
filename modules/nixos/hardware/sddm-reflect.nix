# modules/nixos/hardware/sddm-reflect.nix
#
# SDDM com sddm-astronaut-theme (Qt6, NixOS 25.05+).
#
# kdePackages.qtmultimedia em extraPackages é obrigatório — bug nixpkgs #390251:
# não é puxado como dependência automática e o tema falha silenciosamente sem ele.
#
# Para testar sem reiniciar:
#   sudo -u sddm sddm-greeter-qt6 --test-mode \
#     --theme /run/current-system/sw/share/sddm/themes/sddm-astronaut-theme
#
# Temas disponíveis: astronaut (padrão), black_hole, jake_the_dog,
#   japanese_aesthetic, post_apocalipse, pixel_sakura

{ pkgs, ... }:

let
  sddm-astronaut = pkgs.sddm-astronaut.override {
    # embeddedTheme = "black_hole";  # descomente para trocar
    themeConfig = {
      # Paleta Tokyo Night Dark — consistente com stylix.base16Scheme
      AccentColor    = "#7aa2f7";
      BackgroundColor = "#1a1b26";
      MainColor      = "#c0caf5";
      FormPosition   = "center";
      # Background = toString /home/lucasxll/Pictures/wallpapers/sddm.png;
    };
  };
in
{
  environment.systemPackages = [ sddm-astronaut ];

  services.displayManager.sddm = {
    enable  = true;
    package = pkgs.kdePackages.sddm;  # força Qt6
    theme   = "sddm-astronaut-theme";
    extraPackages = [
      sddm-astronaut
      pkgs.kdePackages.qtmultimedia
    ];
    wayland.enable = true;
    settings = {
      General.RememberLastUser    = false;
      General.RememberLastSession = false;
      Users.RememberLastUser      = false;
    };
  };
}
