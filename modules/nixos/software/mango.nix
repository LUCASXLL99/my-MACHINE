{ pkgs, ... }:

# Baseado no README/dotfiles de https://codeberg.org/theblackdon/mango-fedora
# e na doc oficial do mangowm. NÃO portei o install.sh dele (é script
# dnf/Fedora, não Nix) nem os dotfiles binários/tema SDDM — só o que dava
# pra traduzir de forma segura e declarativa:
#   - portal correto pro Wayland (resolve o TODO deixado em obs-wayland.nix)
#   - cursor + fonte de emoji que ele usa
#   - mangohud (overlay de FPS, útil, leve)
#   - config base do mango (gaps/animações), fácil de você editar depois

{
  programs.mango.enable = true;

  # xdg-desktop-portal-wlr: mango é wlroots/dwl, não expõe a interface do
  # Mutter como o niri fazia — sem isso, captura de tela (grim/OBS) fica
  # sem backend correto.
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
  };

  environment.systemPackages = [
    pkgs.xwayland-satellite
    pkgs.bibata-cursors        # cursor usado no mango-fedora
    pkgs.noto-fonts-emoji      # google-noto-color-emoji-fonts
    pkgs.mangohud              # overlay de FPS/hardware, leve e opcional
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XCURSOR_THEME   = "Bibata-Modern-Classic";
    XCURSOR_SIZE    = "24";
  };
}
