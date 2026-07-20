{ pkgs, ... }:

# Config do WezTerm via home-manager.
#
# O pacote em si já é instalado no nível de sistema (veja
# modules/nixos/software/default-terminal.nix e
# modules/nixos/system/packages.nix). Aqui a gente só cuida da config
# de usuário (~/.config/wezterm/wezterm.lua), gerada declarativamente.
{
  programs.wezterm = {
    enable = true;
    # Não deixa o home-manager instalar outro pacote do wezterm — já
    # vem do nível de sistema.
    package = null;

    extraConfig = ''
      local wezterm = require("wezterm")
      local config = wezterm.config_builder()

      -- Mata qualquer "piscada" de texto vinda de sequência ANSI
      -- (SGR 5/6 - blink), que é o que fazia todo comando parecer
      -- piscando na tela. Sem isso o WezTerm renderiza o blink de
      -- verdade quando algum programa (prompt, ls colorido, etc)
      -- manda esse atributo sem querer.
      config.text_blink_rate = 0
      config.text_blink_rate_rapid = 0

      -- Cursor sólido, sem piscar (efeito colateral parecido, mas
      -- é uma coisa diferente do blink de texto acima).
      config.cursor_blink_rate = 0
      config.default_cursor_style = "SteadyBlock"

      -- Bell silencioso, sem flash visual na tela.
      config.audible_bell = "Disabled"
      config.visual_bell = {
        fade_in_duration_ms = 0,
        fade_out_duration_ms = 0,
      }

      return config
    '';
  };
}
