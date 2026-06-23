# ══════════════════════════════════════════════════════════════════════════════
# SDDM — registro de sessões e tema visual
# ══════════════════════════════════════════════════════════════════════════════
#
# O SDDM não é mais o display-manager ativo — esse papel foi assumido pelo
# greetd (greetd-autologin.nix). O SDDM permanece habilitado aqui por dois
# motivos:
#
#   1. Registra as sessões (niri, bspwm) em xsessions/ e wayland-sessions/
#      para que outros softwares (portais XDG, loginctl) as reconheçam.
#
#   2. O tema sddm-astronaut fica disponível no sistema para quando o greetd
#      invocar o sddm-greeter como greeter de fallback ao matar a sessão.
#
# Autologin removido daqui — configurado no greetd-autologin.nix.
# display-manager.service desabilitado em greetd-autologin.nix via mkForce.

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
      # Sem Autologin aqui — gerenciado pelo greetd (greetd-autologin.nix)
    };
  };
}
