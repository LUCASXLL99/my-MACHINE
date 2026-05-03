# home/lucasxll/modules/terminals.nix
#
# WezTerm e Kitty.
#
# KITTY: cores gerenciadas pelo Stylix (stylix.targets.kitty.enable = true).
#        Apenas layout, fonte e atalhos ficam aqui.
#
# WEZTERM: Stylix desativado (wezterm usa Lua, integração mais complexa).
#          As cores Tokyo Night estão hardcoded no extraConfig Lua.
#          Para migrar: ativar stylix.targets.wezterm em stylix.nix e remover
#          `config.color_scheme = 'Tokyo Night'` do extraConfig.

{ lib, ... }:

{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local config = wezterm.config_builder()
      local act    = wezterm.action

      -- ── Fonte ────────────────────────────────────────────────────
      config.font      = wezterm.font('JetBrainsMono Nerd Font', { weight = 'Regular' })
      config.font_size = 14.0
      config.line_height = 1.2

      config.freetype_load_target   = 'Light'
      config.freetype_render_target = 'HorizontalLcd'

      -- ── Cores ────────────────────────────────────────────────────
      -- NOTA: quando stylix.targets.wezterm = true, remover esta linha
      -- e deixar Stylix injetar a paleta automaticamente
      config.color_scheme = 'Tokyo Night'

      -- ── Layout ───────────────────────────────────────────────────
      config.tab_bar_at_bottom  = false
      config.use_fancy_tab_bar  = false
      config.enable_scroll_bar  = true
      config.scrollback_lines   = 5000
      config.window_padding     = { left = 8, right = 14, top = 6, bottom = 6 }

      -- ── Cursor ───────────────────────────────────────────────────
      config.default_cursor_style = 'BlinkingBlock'
      config.cursor_blink_rate    = 500

      -- ── Janela ───────────────────────────────────────────────────
      config.window_decorations        = "RESIZE"
      config.window_background_opacity = 0.82

      -- ── Atalhos ──────────────────────────────────────────────────
      config.keys = {
        {
          key = 'c', mods = 'CTRL',
          action = wezterm.action_callback(function(window, pane)
            local has_selection = window:get_selection_text_for_pane(pane) ~= ""
            if has_selection then
              window:perform_action(act.CopyTo 'Clipboard', pane)
            else
              window:perform_action(act.SendKey { key = 'c', mods = 'CTRL' }, pane)
            end
          end),
        },
        { key = 'v', mods = 'CTRL',       action = act.PasteFrom 'Clipboard' },
        { key = 'a', mods = 'CTRL|SHIFT', action = act.SelectTextAtMouseCursor 'SemanticZone' },

        { key = 't', mods = 'ALT', action = act.SpawnTab 'CurrentPaneDomain' },
        { key = 'w', mods = 'ALT', action = act.CloseCurrentTab { confirm = false } },
        { key = 's', mods = 'ALT', action = act.SplitVertical   { domain = 'CurrentPaneDomain' } },
        { key = 'd', mods = 'ALT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
        { key = 'h', mods = 'ALT', action = act.ActivatePaneDirection 'Left'  },
        { key = 'l', mods = 'ALT', action = act.ActivatePaneDirection 'Right' },
        { key = 'k', mods = 'ALT', action = act.ActivatePaneDirection 'Up'    },
        { key = 'j', mods = 'ALT', action = act.ActivatePaneDirection 'Down'  },
        { key = 'n', mods = 'ALT', action = act.ActivateTabRelative(1)  },
        { key = 'p', mods = 'ALT', action = act.ActivateTabRelative(-1) },
        { key = 'z', mods = 'ALT', action = act.TogglePaneZoomState     },

        { key = '+', mods = 'CTRL', action = act.IncreaseFontSize },
        { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
        { key = '0', mods = 'CTRL', action = act.ResetFontSize    },
      }

      -- ── Mouse ────────────────────────────────────────────────────
      config.mouse_bindings = {
        {
          event  = { Down = { streak = 1, button = 'Right' } },
          mods   = 'NONE',
          action = act.PasteFrom 'PrimarySelection',
        },
      }

      return config
    '';
  };

}
