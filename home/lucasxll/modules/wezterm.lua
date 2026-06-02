-- ~/.config/wezterm/wezterm.lua
-- WezTerm adaptado para canhoto + tela espelhada
-- Barra de abas à direita, layout espelhado

local wezterm = require 'wezterm'
local config  = wezterm.config_builder()

-- ── Aparência ────────────────────────────────────────────────
config.color_scheme = 'Github Dark'
config.font = wezterm.font('JetBrainsMono Nerd Font', { weight = 'Regular' })
config.font_size = 12.0

-- ── Layout para canhoto ──────────────────────────────────────
-- Barra de abas à direita (mão esquerda alcança mais fácil com tela espelhada)
config.tab_bar_at_bottom  = false
config.use_fancy_tab_bar  = false

-- Barra lateral à direita
config.tab_bar_style = {}

-- Scrollbar à esquerda (visualmente à direita com tela espelhada)
config.enable_scroll_bar    = true
config.scrollback_lines     = 5000

-- ── Atalhos adaptados para canhoto ───────────────────────────
-- Todas as ações importantes no lado direito do teclado
config.keys = {
  -- Nova aba: RAlt + T
  { key = 't', mods = 'RALT', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
  -- Fechar aba: RAlt + W
  { key = 'w', mods = 'RALT', action = wezterm.action.CloseCurrentTab { confirm = false } },
  -- Split vertical: RAlt + S
  { key = 's', mods = 'RALT', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
  -- Split horizontal: RAlt + D
  { key = 'd', mods = 'RALT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  -- Navegar entre painéis: RAlt + hjkl
  { key = 'h', mods = 'RALT', action = wezterm.action.ActivatePaneDirection 'Left'  },
  { key = 'l', mods = 'RALT', action = wezterm.action.ActivatePaneDirection 'Right' },
  { key = 'k', mods = 'RALT', action = wezterm.action.ActivatePaneDirection 'Up'    },
  { key = 'j', mods = 'RALT', action = wezterm.action.ActivatePaneDirection 'Down'  },
  -- Navegar entre abas: RAlt + n/p
  { key = 'n', mods = 'RALT', action = wezterm.action.ActivateTabRelative(1)  },
  { key = 'p', mods = 'RALT', action = wezterm.action.ActivateTabRelative(-1) },
  -- Copiar/colar: RAlt + c/v
  { key = 'c', mods = 'RALT', action = wezterm.action.CopyTo 'Clipboard' },
  { key = 'v', mods = 'RALT', action = wezterm.action.PasteFrom 'Clipboard' },
  -- Zoom no painel atual: RAlt + Z
  { key = 'z', mods = 'RALT', action = wezterm.action.TogglePaneZoomState },
}

-- ── Padding (espaço nas bordas) ───────────────────────────────
config.window_padding = {
  left   = 4,
  right  = 12,  -- scrollbar fica aqui
  top    = 4,
  bottom = 4,
}

-- ── Cursor ───────────────────────────────────────────────────
config.default_cursor_style   = 'BlinkingBar'
config.cursor_blink_rate      = 500

-- ── Janela ───────────────────────────────────────────────────
config.window_decorations         = "RESIZE"
config.window_background_opacity  = 0.95
config.macos_window_background_blur = 0

return config
