# SDDM Qt6 com sddm-astronaut-theme.
# kdePackages.qtmultimedia em extraPackages é obrigatório (bug nixpkgs #390251).
# Autologin.Relogin = false: evita loop se a sessão encerrar inesperadamente.
#
# wayland.enable = true: OBRIGATÓRIO para sessões Wayland (niri).
# Sem isso, o SDDM opera em modo X11 puro e nunca expõe
# /run/current-system/sw/share/wayland-sessions/ — o niri.desktop fica
# invisível para o display manager e o autologin não encontra a sessão.

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
    enable         = true;
    package        = pkgs.kdePackages.sddm;
    wayland.enable = true;
    theme          = "sddm-astronaut-theme";
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
