# modules/nixos/hardware/sddm-reflect.nix
# SDDM Qt6 com sddm-astronaut-theme.
#
# kdePackages.qtmultimedia em extraPackages é obrigatório (bug nixpkgs #390251).
# wayland.enable = true (padrão) — o SDDM Qt6 usa compositor interno próprio,
# não precisa do kwin. Necessário para o autologin conseguir iniciar sessões
# Wayland (como niri) corretamente.
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
      pkgs.kdePackages.qtmultimedia   # obrigatório: bug nixpkgs #390251
      pkgs.kdePackages.qtwayland       # plugin Wayland para o greeter Qt6
    ];
    settings = {
      General.RememberLastUser    = false;
      General.RememberLastSession = false;
      Users.RememberLastUser      = false;

      Autologin.User    = "lucasxll";
      Autologin.Session = "niri";
      # true: retenta autologin se niri crashar no boot (ex: race condition).
      # Se entrar em loop: Ctrl+Alt+F2 → TTY → nixos-rebuild switch para corrigir.
      Autologin.Relogin = true;
    };
  };
}
