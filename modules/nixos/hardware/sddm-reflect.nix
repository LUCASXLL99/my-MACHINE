# SDDM Qt6 com sddm-astronaut-theme.
# kdePackages.qtmultimedia em extraPackages é obrigatório (bug nixpkgs #390251).
# Autologin.Relogin = false: evita loop se a sessão encerrar inesperadamente.
#
# wayland.enable = false (padrão): SDDM roda em modo X11 no VT 7.
# Com wayland.enable = true, o SDDM sobe seu próprio compositor Wayland
# (kwin_wayland) no VT 7 e o autologin tenta iniciar niri-session no mesmo
# VT — conflito de DRM, niri sai em ~3s e o SDDM mostra o greeter.
# No modo X11, o autologin abre o niri-session em um VT livre (VT 1/2)
# sem conflito. O niri.desktop é encontrado via environment.etc +
# pathsToLink em niri.nix, portanto o modo X11 funciona corretamente.

{ pkgs, ... }:

let
  sddm-astronaut = pkgs.sddm-astronaut.override {
    themeConfig = {
      AccentColor     = "#7aa2f7";
      BackgroundColor = "#1a1b26";
      MainColor       = "#c0caf5";
      FormPosition    = "center";
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
      pkgs.kdePackages.qtwayland
    ];
    settings = {
      General.RememberLastUser    = false;
      General.RememberLastSession = false;
      Users.RememberLastUser      = false;
      Autologin.User    = "lucasxll";
      Autologin.Session = "niri";
      Autologin.Relogin = false;
    };
  };
}
