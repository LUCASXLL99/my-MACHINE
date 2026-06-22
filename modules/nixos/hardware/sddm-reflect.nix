# wayland.enable = false (padrão): SDDM roda em X11 no VT 7.
# Com wayland.enable = true, o SDDM sobe kwin_wayland no mesmo VT e o
# autologin conflita com o niri → sessão encerra em ~3s.
# Autologin.Relogin = false: evita loop se a sessão encerrar inesperadamente.

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
      pkgs.kdePackages.qtmultimedia  # obrigatório: bug nixpkgs #390251
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
