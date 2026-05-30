# modules/nixos/hardware/sddm-reflect.nix
#
# SDDM — greeter Qt6 com sddm-astronaut-theme.
#
# ── Por que funciona agora (nixpkgs 25.05 + SDDM 0.21) ──────────────────
#   • SDDM 0.21 usa Qt6 nativamente — package = pkgs.kdePackages.sddm
#   • pkgs.sddm-astronaut é o pacote oficial nixpkgs do tema (Qt6)
#   • kdePackages.qtmultimedia precisa ser passado explicitamente em
#     extraPackages — bug nixpkgs #390251: ele não é puxado como dep
#     automaticamente e o tema falha silenciosamente sem ele.
#
# ── Temas disponíveis via embeddedTheme ─────────────────────────────────
#   "astronaut" (padrão), "black_hole", "jake_the_dog",
#   "japanese_aesthetic", "post_apocalipse", "pixel_sakura"
#
# ── Preview sem reiniciar ────────────────────────────────────────────────
#   sudo -u sddm sddm-greeter-qt6 --test-mode \
#     --theme /run/current-system/sw/share/sddm/themes/sddm-astronaut-theme

{ pkgs, ... }:

let
  sddm-astronaut = pkgs.sddm-astronaut.override {
    # Para trocar de variante, descomente e escolha uma:
    # embeddedTheme = "black_hole";

    themeConfig = {
      # ── Paleta Tokyo Night Dark ────────────────────────────────
      # Consistente com stylix.base16Scheme declarado no default.nix
      AccentColor    = "#7aa2f7";   # base0D — blue (funções/atributos)
      BackgroundColor = "#1a1b26";  # base00 — bg principal
      MainColor      = "#c0caf5";   # base05 — fg principal

      # Posição do formulário de login: "left" | "center" | "right"
      FormPosition   = "center";

      # ── Fundo ─────────────────────────────────────────────────
      # Vazio = usa o wallpaper padrão do tema escolhido.
      # Para imagem própria, descomente e ajuste o caminho:
      # Background = toString /home/lucasxll/Pictures/wallpapers/sddm.png;
    };
  };
in
{
  # O pacote do tema precisa estar em systemPackages para que o SDDM
  # encontre o diretório /run/current-system/sw/share/sddm/themes/...
  environment.systemPackages = [ sddm-astronaut ];

  services.displayManager.sddm = {
    enable  = true;

    # Força SDDM Qt6 — sem isso o NixOS pode usar a variante Qt5 legada
    package = pkgs.kdePackages.sddm;

    theme   = "sddm-astronaut-theme";

    # extraPackages: pacotes disponibilizados para o processo do SDDM
    # (greeter roda como usuário sddm, separado do ambiente do usuário)
    extraPackages = [
      sddm-astronaut
      pkgs.kdePackages.qtmultimedia  # necessário — bug nixpkgs #390251
    ];

    # Habilita o compositor Wayland interno do SDDM 0.21.
    # Sem isso o SDDM inicia em modo X11 e o tema pode não renderizar.
    wayland.enable = true;

    settings = {
      General = {
        # Não lembra último usuário/sessão — evita conflito com autologin
        # e não tenta iniciar niri quando já há sessão ativa no logind
        RememberLastUser    = false;
        RememberLastSession = false;
      };
      Users.RememberLastUser = false;
    };
  };
}
