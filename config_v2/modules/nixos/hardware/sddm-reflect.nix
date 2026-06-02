# modules/nixos/hardware/sddm-reflect.nix
# SDDM Qt6 com sddm-astronaut-theme.
#
# kdePackages.qtmultimedia em extraPackages é obrigatório (bug nixpkgs #390251).
# wayland.enable = false — kwin não está instalado; greeter roda em X11.
#
# Testar sem reiniciar:
#   sudo -u sddm sddm-greeter-qt6 --test-mode \
#     --theme /run/current-system/sw/share/sddm/themes/sddm-astronaut-theme

{ pkgs, ... }:

let
  sddm-astronaut = pkgs.sddm-astronaut.override {
    # embeddedTheme = "black_hole";
    themeConfig = {
      AccentColor     = "#7aa2f7";
      BackgroundColor = "#1a1b26";
      MainColor       = "#c0caf5";
      FormPosition    = "center";
      # Background = toString /home/lucasxll/Pictures/wallpapers/sddm.png;
    };
  };
in
{
  environment.systemPackages = [ sddm-astronaut ];

  services.displayManager.sddm = {
    enable  = true;
    package = pkgs.kdePackages.sddm;
    theme   = "sddm-astronaut-theme";
    extraPackages = [
      sddm-astronaut
      pkgs.kdePackages.qtmultimedia
    ];
    wayland.enable = false;
    settings = {
      General.RememberLastUser    = false;
      General.RememberLastSession = false;
      Users.RememberLastUser      = false;

      # SDDM Qt6 com tema customizado ignora services.displayManager.autoLogin.
      # Relogin = false evita loop se a sessão travar no boot.
      Autologin.User    = "lucasxll";
      Autologin.Session = "niri";
      Autologin.Relogin = false;
    };
  };
}
