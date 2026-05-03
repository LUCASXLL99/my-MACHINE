# home/lucasxll/modules/neovim.nix
#
# Neovim declarativo via Home Manager.
#
# Stack:
#   LSP     — nil (Nix), pyright (Python), lua-language-server (Lua)
#   Syntax  — nvim-treesitter (highlighting semântico)
#   Search  — telescope-nvim + ripgrep/fd (já instalados pelo lf.nix)
#   UI      — lualine, which-key, nvim-web-devicons, tokyonight
#   Cmp     — nvim-cmp + cmp-nvim-lsp + luasnip
#
# Por que declarativo em vez de Mason?
# Mason baixa binários na runtime — não reproduzível, quebra offline.
# No NixOS, os LSP servers são pacotes Nix: versionados, reproduzíveis,
# e disponíveis mesmo sem internet.
#
# Leader = Space (padrão moderno, fácil de alcançar para ambas as mãos)

{ pkgs, ... }:

{
  programs.neovim = {
    enable        = true;
    defaultEditor = true;   # EDITOR=nvim — usado pelo git, ranger, etc.
    viAlias       = true;   # vi → nvim
    vimAlias      = true;   # vim → nvim

    # ── LSP servers e ferramentas externas ─────────────────────
    extraPackages = with pkgs; [
      # LSP servers
      nil                    # Nix — análise estática, formatação, go-to-def
      pyright                # Python — type checking + completion
      lua-language-server    # Lua — relevante para wezterm.lua e nvim config

      # Telescope precisa destas ferramentas (já instaladas pelo lf.nix,
      # mas declarados aqui para garantir no contexto do nvim)
      ripgrep
      fd
    ];

    # ── Plugins ────────────────────────────────────────────────
    plugins = with pkgs.vimPlugins; [

      # Dependência compartilhada
      plenary-nvim

      # ── Tema ─────────────────────────────────────────────────
      # Tokyo Night — consistente com o resto do sistema
      # Se stylix.targets.neovim existir no futuro, remover isto
      {
        plugin = tokyonight-nvim;
        type   = "lua";
        config = ''
          require('tokyonight').setup({
            style        = "night",   -- "night" = #1a1b26 (igual ao resto)
            transparent  = true,      -- fundo transparente (picom/niri blur)
            terminal_colors = true,
            styles = {
              comments   = { italic = true },
              keywords   = { italic = true },
              functions  = {},
              variables  = {},
            },
          })
          vim.cmd("colorscheme tokyonight-night")
        '';
      }

      # ── Statusline ───────────────────────────────────────────
      nvim-web-devicons
      {
        plugin = lualine-nvim;
        type   = "lua";
        config = ''
          require('lualine').setup({
            options = {
              theme            = 'tokyonight',
              section_separators   = { left = '''', right = '''' },
              component_separators = { left = '''', right = '''' },
              globalstatus     = true,
            },
            sections = {
              lualine_a = { 'mode' },
              lualine_b = { 'branch', 'diff', 'diagnostics' },
              lualine_c = { { 'filename', path = 1 } },
              lualine_x = { 'encoding', 'fileformat', 'filetype' },
              lualine_y = { 'progress' },
              lualine_z = { 'location' },
            },
          })
        '';
      }

      # ── Which-key: mostra atalhos disponíveis ─────────────────
      {
        plugin = which-key-nvim;
        type   = "lua";
        config = ''
          require('which-key').setup({
            delay = 400,  -- ms antes de aparecer
          })
        '';
      }

      # ── Treesitter — syntax highlighting semântico ────────────
      {
        plugin = (nvim-treesitter.withPlugins (p: with p; [
          nix bash python lua
          javascript typescript json yaml toml
          markdown markdown_inline
          html css
          c cpp
          vim vimdoc query # necessário para o próprio treesitter
        ]));
        type   = "lua";
        config = ''
          require('nvim-treesitter.configs').setup({
            highlight = {
              enable   = true,
              -- Desativa para arquivos grandes (> 100KB) para manter performance
              disable  = function(lang, buf)
                local max_filesize = 100 * 1024
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then return true end
              end,
            },
            indent = { enable = true },
          })
        '';
      }

      # ── LSP config ───────────────────────────────────────────
      {
        plugin = nvim-lspconfig;
        type   = "lua";
        config = ''
          local lspconfig = require('lspconfig')
          local capabilities = require('cmp_nvim_lsp').default_capabilities()

          -- ── Nix LSP (nil) ─────────────────────────────────────
          lspconfig.nil_ls.setup({
            capabilities = capabilities,
            settings = {
              ['nil'] = {
                formatting = { command = { "nixpkgs-fmt" } },
                nix = { flake = { autoEvalInputs = false } },
              },
            },
          })

          -- ── Python LSP (pyright) ──────────────────────────────
          lspconfig.pyright.setup({
            capabilities = capabilities,
            settings = {
              python = {
                analysis = {
                  typeCheckingMode   = "basic",
                  autoSearchPaths    = true,
                  useLibraryCodeForTypes = true,
                },
              },
            },
          })

          -- ── Lua LSP ───────────────────────────────────────────
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                runtime    = { version = 'LuaJIT' },
                workspace  = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file("", true) },
                telemetry  = { enable = false },
                diagnostics = { globals = { 'vim', 'wezterm' } },
              },
            },
          })

          -- ── Atalhos LSP (disponíveis quando LSP conecta) ──────
          vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('LspKeymaps', {}),
            callback = function(ev)
              local opts = { buffer = ev.buf, silent = true }
              vim.keymap.set('n', 'gd',        vim.lsp.buf.definition,      vim.tbl_extend('force', opts, { desc = 'Go to Definition' }))
              vim.keymap.set('n', 'gD',        vim.lsp.buf.declaration,     vim.tbl_extend('force', opts, { desc = 'Go to Declaration' }))
              vim.keymap.set('n', 'gr',        vim.lsp.buf.references,      vim.tbl_extend('force', opts, { desc = 'References' }))
              vim.keymap.set('n', 'gi',        vim.lsp.buf.implementation,  vim.tbl_extend('force', opts, { desc = 'Go to Implementation' }))
              vim.keymap.set('n', 'K',         vim.lsp.buf.hover,           vim.tbl_extend('force', opts, { desc = 'Hover Documentation' }))
              vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,         vim.tbl_extend('force', opts, { desc = 'Rename' }))
              vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action,    vim.tbl_extend('force', opts, { desc = 'Code Action' }))
              vim.keymap.set('n', '<leader>f',  function() vim.lsp.buf.format({ async = true }) end, vim.tbl_extend('force', opts, { desc = 'Format' }))
              vim.keymap.set('n', '[d',        vim.diagnostic.goto_prev,    vim.tbl_extend('force', opts, { desc = 'Prev Diagnostic' }))
              vim.keymap.set('n', ']d',        vim.diagnostic.goto_next,    vim.tbl_extend('force', opts, { desc = 'Next Diagnostic' }))
              vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float,   vim.tbl_extend('force', opts, { desc = 'Show Diagnostics' }))
            end,
          })

          -- Ícones de diagnóstico na gutter
          local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
          for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
          end
        '';
      }

      # ── Completion (nvim-cmp) ─────────────────────────────────
      luasnip
      cmp_luasnip
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      {
        plugin = nvim-cmp;
        type   = "lua";
        config = ''
          local cmp     = require('cmp')
          local luasnip = require('luasnip')

          cmp.setup({
            snippet = {
              expand = function(args) luasnip.lsp_expand(args.body) end,
            },
            mapping = cmp.mapping.preset.insert({
              ['<C-b>']     = cmp.mapping.scroll_docs(-4),
              ['<C-f>']     = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<C-e>']     = cmp.mapping.abort(),
              -- Enter confirma apenas se algo estiver selecionado explicitamente
              ['<CR>']      = cmp.mapping.confirm({ select = false }),
              -- Tab navega pelos itens
              ['<Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
                else fallback()
                end
              end, { 'i', 's' }),
              ['<S-Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then luasnip.jump(-1)
                else fallback()
                end
              end, { 'i', 's' }),
            }),
            sources = cmp.config.sources({
              { name = 'nvim_lsp' },
              { name = 'luasnip'  },
              { name = 'path'     },
            }, {
              { name = 'buffer' },
            }),
            formatting = {
              format = function(entry, vim_item)
                local icons = {
                  nvim_lsp = "󰒋", luasnip = "", buffer = "󰦨",
                  path = "󰉋",
                }
                vim_item.menu = icons[entry.source.name]
                return vim_item
              end,
            },
          })
        '';
      }

      # ── Telescope — fuzzy finder universal ───────────────────
      telescope-fzf-native-nvim
      {
        plugin = telescope-nvim;
        type   = "lua";
        config = ''
          local telescope = require('telescope')
          local builtin   = require('telescope.builtin')
          local actions   = require('telescope.actions')

          telescope.setup({
            defaults = {
              mappings = {
                i = {
                  ['<C-k>'] = actions.move_selection_previous,
                  ['<C-j>'] = actions.move_selection_next,
                  ['<Esc>'] = actions.close,
                },
              },
              -- Usa fd para listar arquivos (mais rápido, respeita .gitignore)
              find_command = { 'fd', '--type', 'f', '--hidden', '--exclude', '.git' },
              vimgrep_arguments = {
                'rg', '--color=never', '--no-heading', '--with-filename',
                '--line-number', '--column', '--smart-case', '--hidden',
                '--glob=!.git/',
              },
            },
            extensions = {
              fzf = {
                fuzzy                   = true,
                override_generic_sorter = true,
                override_file_sorter    = true,
                case_mode               = "smart_case",
              },
            },
          })

          telescope.load_extension('fzf')

          -- Atalhos Telescope sob <leader>s (search)
          vim.keymap.set('n', '<leader>sf', builtin.find_files,    { desc = 'Search Files' })
          vim.keymap.set('n', '<leader>sg', builtin.live_grep,     { desc = 'Search Grep' })
          vim.keymap.set('n', '<leader>sb', builtin.buffers,       { desc = 'Search Buffers' })
          vim.keymap.set('n', '<leader>sh', builtin.help_tags,     { desc = 'Search Help' })
          vim.keymap.set('n', '<leader>sr', builtin.oldfiles,      { desc = 'Search Recent' })
          vim.keymap.set('n', '<leader>sd', builtin.diagnostics,   { desc = 'Search Diagnostics' })
          vim.keymap.set('n', '<leader>sk', builtin.keymaps,       { desc = 'Search Keymaps' })
          vim.keymap.set('n', '<leader>/',  builtin.current_buffer_fuzzy_find, { desc = 'Search in Buffer' })

          -- Ctrl+P: atalho rápido para arquivos (muscle memory universal)
          vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = 'Find Files' })
        '';
      }

    ]; # fim plugins

    # ── Config Lua principal ──────────────────────────────────
    extraLuaConfig = ''
      -- ── Leader ────────────────────────────────────────────────
      -- Deve ser definido ANTES dos plugins que usam <leader>
      vim.g.mapleader      = " "
      vim.g.maplocalleader = " "

      -- ── Opções gerais ─────────────────────────────────────────
      local opt = vim.opt

      opt.number         = true   -- números de linha absolutos
      opt.relativenumber = true   -- números relativos (navegar com [N]j/k)
      opt.cursorline     = true   -- destaca a linha do cursor
      opt.signcolumn     = "yes"  -- reserva espaço para gutter (LSP signs)
      opt.wrap           = false  -- sem quebra de linha automática
      opt.scrolloff      = 8     -- mantém 8 linhas de contexto ao rolar
      opt.sidescrolloff  = 8

      -- ── Indentação ────────────────────────────────────────────
      opt.tabstop     = 2
      opt.shiftwidth  = 2
      opt.expandtab   = true
      opt.smartindent = true

      -- ── Busca ────────────────────────────────────────────────
      opt.ignorecase = true  -- case-insensitive por padrão
      opt.smartcase  = true  -- case-sensitive se tiver maiúscula
      opt.hlsearch   = false -- não destaca após busca terminar
      opt.incsearch  = true  -- destaca enquanto digita

      -- ── Performance ──────────────────────────────────────────
      opt.updatetime = 250   -- tempo para CursorHold (LSP hover, etc.)
      opt.timeoutlen = 400   -- ms para which-key aparecer

      -- ── Clipboard ────────────────────────────────────────────
      -- Integração com o clipboard do sistema (requer xclip/wl-clipboard)
      opt.clipboard = "unnamedplus"

      -- ── Aparência ────────────────────────────────────────────
      opt.termguicolors = true
      opt.background    = "dark"
      opt.showmode      = false   -- lualine já mostra o modo

      -- ── Splits ───────────────────────────────────────────────
      opt.splitright = true  -- novo split vertical → direita
      opt.splitbelow = true  -- novo split horizontal → baixo

      -- ── Atalhos globais ──────────────────────────────────────
      local map = vim.keymap.set

      -- Salvar com Ctrl+S
      map({ 'n', 'i', 'v' }, '<C-s>', '<cmd>w<CR>', { desc = 'Save' })

      -- Sair sem salvar
      map('n', '<leader>q', '<cmd>q<CR>', { desc = 'Quit' })

      -- Navegar entre splits (hjkl sem precisar de Ctrl+W)
      map('n', '<C-h>', '<C-w>h', { desc = 'Move to left split' })
      map('n', '<C-j>', '<C-w>j', { desc = 'Move to lower split' })
      map('n', '<C-k>', '<C-w>k', { desc = 'Move to upper split' })
      map('n', '<C-l>', '<C-w>l', { desc = 'Move to right split' })

      -- Navegar buffers
      map('n', '<S-l>', '<cmd>bnext<CR>',     { desc = 'Next Buffer' })
      map('n', '<S-h>', '<cmd>bprevious<CR>', { desc = 'Prev Buffer' })
      map('n', '<leader>bd', '<cmd>bd<CR>',   { desc = 'Close Buffer' })

      -- Mover linhas selecionadas (visual mode)
      map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
      map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

      -- Centralizar cursor após navegação
      map('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down + center' })
      map('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up + center' })
      map('n', 'n',     'nzzzv',   { desc = 'Next search result + center' })
      map('n', 'N',     'Nzzzv',   { desc = 'Prev search result + center' })

      -- Limpar highlight da busca
      map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

      -- Remover a armadilha do Q (ex mode)
      map('n', 'Q', '<nop>')
    '';
  };
}
