{ lib, ... }:
{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local config = wezterm.config_builder()
      local act    = wezterm.action
      config.font      = wezterm.font('JetBrainsMono Nerd Font', { weight = 'Regular' })
      config.font_size = 14.0
      config.line_height = 1.2
      config.freetype_load_target   = 'Light'
      config.freetype_render_target = 'HorizontalLcd'
      config.color_scheme = 'Tokyo Night'
      config.tab_bar_at_bottom  = false
      config.use_fancy_tab_bar  = false
      config.enable_scroll_bar  = true
      config.scrollback_lines   = 5000
      config.window_padding     = { left = 8, right = 14, top = 6, bottom = 20 }
      config.default_cursor_style = 'BlinkingBlock'
      config.cursor_blink_rate    = 500
      config.window_decorations        = "RESIZE"
      config.window_background_opacity = 0.82
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
        -- Libera Ctrl+Shift+U pro IBus (entrada Unicode hex do QMK).
        -- Sem isso, o WezTerm intercepta esse atalho pro CharSelect dele.
        { key = 'u', mods = 'CTRL|SHIFT', action = act.DisableDefaultAssignment },
      }
      -- Botão direito: seleciona + copia para PrimarySelection (Down=Select evita bloquear drag).
      config.mouse_bindings = {
        {
          event  = { Down = { streak = 1, button = 'Right' } },
          mods   = 'NONE',
          action = act.SelectTextAtMouseCursor 'Cell',
        },
        {
          event  = { Drag = { streak = 1, button = 'Right' } },
          mods   = 'NONE',
          action = act.ExtendSelectionToMouseCursor 'Cell',
        },
        {
          event  = { Up = { streak = 1, button = 'Right' } },
          mods   = 'NONE',
          action = act.CompleteSelectionOrOpenLinkAtMouseCursor 'PrimarySelection',
        },
      }
      return config
    '';
  };
}
