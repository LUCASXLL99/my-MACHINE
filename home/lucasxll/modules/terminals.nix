# home/lucasxll/modules/terminals.nix

{ ... }:

{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require 'wezterm'
      local config  = wezterm.config_builder()
      local act     = wezterm.action

      config.font = wezterm.font('JetBrainsMono Nerd Font', { weight = 'Regular' })
      config.font_size = 12.0
      config.color_scheme = 'Github Dark'

      config.tab_bar_at_bottom      = false
      config.use_fancy_tab_bar      = false
      config.enable_scroll_bar      = true
      config.scrollback_lines       = 5000
      config.window_padding         = { left = 4, right = 12, top = 4, bottom = 4 }
      config.default_cursor_style   = 'BlinkingBar'
      config.cursor_blink_rate      = 500
      config.window_decorations     = "RESIZE"
      config.window_background_opacity = 0.95

      -- Ctrl+C: copia se tiver seleção, senão manda SIGINT (comportamento inteligente)
      -- Ctrl+V: cola sempre
      -- Ctrl+A: seleciona tudo
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
        { key = 'v', mods = 'CTRL',      action = act.PasteFrom 'Clipboard' },
        { key = 'a', mods = 'CTRL|SHIFT', action = act.SelectTextAtMouseCursor 'SemanticZone' },

        -- Atalhos de janela via RAlt
        { key = 't', mods = 'RALT', action = act.SpawnTab 'CurrentPaneDomain' },
        { key = 'w', mods = 'RALT', action = act.CloseCurrentTab { confirm = false } },
        { key = 's', mods = 'RALT', action = act.SplitVertical   { domain = 'CurrentPaneDomain' } },
        { key = 'd', mods = 'RALT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
        { key = 'h', mods = 'RALT', action = act.ActivatePaneDirection 'Left'  },
        { key = 'l', mods = 'RALT', action = act.ActivatePaneDirection 'Right' },
        { key = 'k', mods = 'RALT', action = act.ActivatePaneDirection 'Up'    },
        { key = 'j', mods = 'RALT', action = act.ActivatePaneDirection 'Down'  },
        { key = 'n', mods = 'RALT', action = act.ActivateTabRelative(1)  },
        { key = 'p', mods = 'RALT', action = act.ActivateTabRelative(-1) },
        { key = 'z', mods = 'RALT', action = act.TogglePaneZoomState     },
      }

      -- Clique direito cola (igual ao terminal clássico do Linux)
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

  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };
    settings = {
      tab_bar_edge             = "top";
      tab_bar_align            = "right";
      tab_bar_style            = "powerline";
      scrollback_lines         = 5000;
      background_opacity       = "0.95";
      hide_window_decorations  = "yes";
      cursor_blink_interval    = "0.5";
      background               = "#0e1117";
      foreground               = "#e6edf3";
      selection_background     = "#58a6ff";
      selection_foreground     = "#0e1117";
      cursor                   = "#58a6ff";
      active_tab_background    = "#58a6ff";
      active_tab_foreground    = "#0e1117";
      inactive_tab_background  = "#161b22";
      inactive_tab_foreground  = "#8b949e";
      # Ctrl+C/V igual ao sistema
      copy_on_select           = "yes";
    };
    keybindings = {
      # Ctrl+C copia se tiver seleção, senão SIGINT
      "ctrl+c"  = "copy_or_interrupt";
      "ctrl+v"  = "paste_from_clipboard";
      # RAlt para janelas
      "ralt+t"  = "new_tab_with_cwd";
      "ralt+w"  = "close_tab";
      "ralt+n"  = "next_tab";
      "ralt+p"  = "previous_tab";
      "ralt+s"  = "launch --location=hsplit";
      "ralt+d"  = "launch --location=vsplit";
      "ralt+h"  = "neighboring_window left";
      "ralt+l"  = "neighboring_window right";
      "ralt+k"  = "neighboring_window up";
      "ralt+j"  = "neighboring_window down";
      "ralt+z"  = "toggle_layout stack";
      # Clique direito cola
      "mouse_button_right" = "paste_from_selection";
    };
  };
}
