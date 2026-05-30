# home/lucasxll/modules/neovim.nix
#
# Neovim declarativo via Home Manager.
#
# Stack:
#   LSP     — nil (Nix), pyright (Python), lua-language-server (Lua)
#             rust-analyzer (Rust/WASM), ts_ls (JS/TS), html, cssls,
#             jsonls, eslint, emmet, tailwindcss
#   Syntax  — nvim-treesitter (highlighting semântico)
#   Search  — telescope-nvim + ripgrep/fd
#   UI      — lualine, which-key, nvim-web-devicons, tokyonight
#             gitsigns, trouble
#   Edit    — nvim-surround, nvim-autopairs, comment-nvim
#   Format  — conform-nvim (prettier + rustfmt)
#   Debug   — nvim-dap + nvim-dap-ui + codelldb (Rust/C/C++)
#   Cmp     — nvim-cmp + cmp-nvim-lsp + luasnip
#
# Por que declarativo em vez de Mason?
# Mason baixa binários na runtime — não reproduzível, quebra offline.
# No NixOS, os LSP servers são pacotes Nix: versionados, reproduzíveis,
# e disponíveis mesmo sem internet.
#
# Leader = Space

{ pkgs, ... }:

{
  programs.neovim = {
    enable        = true;
    defaultEditor = true;
    viAlias       = true;
    vimAlias      = true;

    # ── LSP servers e ferramentas externas ─────────────────────
    extraPackages = with pkgs; [
      # ── LSP: linguagens existentes ──────────────────────────────────
      nil
      pyright
      lua-language-server

      # ── LSP: Rust ───────────────────────────────────────────────────
      rust-analyzer
      rustfmt

      # ── LSP: Web ────────────────────────────────────────────────────
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      nodePackages."@tailwindcss/language-server"
      emmet-language-server
      nodePackages.prettier
      nodePackages.eslint

      # ── Debugger ────────────────────────────────────────────────────
      lldb
      vscode-extensions.vadimcn.vscode-lldb

      # ── Telescope ───────────────────────────────────────────────────
      ripgrep
      fd
    ];

    plugins = with pkgs.vimPlugins; [

      plenary-nvim

      # ── Tema ─────────────────────────────────────────────────
      {
        plugin = tokyonight-nvim;
        type   = "lua";
        config = ''
          require('tokyonight').setup({
            style        = "night",
            transparent  = true,
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
              section_separators   = { left = "", right = "" },
              component_separators = { left = "", right = "" },
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

      # ── Which-key ─────────────────────────────────────────────
      {
        plugin = which-key-nvim;
        type   = "lua";
        config = ''
          require('which-key').setup({
            delay = 400,
          })
        '';
      }

      # ── Treesitter ────────────────────────────────────────────
      {
        plugin = (nvim-treesitter.withPlugins (p: with p; [
          nix bash python lua
          javascript typescript json yaml toml
          markdown markdown_inline
          html css
          c cpp
          rust
          vim vimdoc query
        ]));
        type   = "lua";
        config = ''
          require('nvim-treesitter.configs').setup({
            highlight = {
              enable   = true,
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

      # ── SchemaStore — schemas JSON para jsonls ────────────────
      SchemaStore-nvim

      # ── LSP config ───────────────────────────────────────────
      {
        plugin = nvim-lspconfig;
        type   = "lua";
        config = ''
          local lspconfig = require('lspconfig')
          local capabilities = require('cmp_nvim_lsp').default_capabilities()

          lspconfig.nil_ls.setup({
            capabilities = capabilities,
            settings = {
              ['nil'] = {
                formatting = { command = { "nixpkgs-fmt" } },
                nix = { flake = { autoEvalInputs = false } },
              },
            },
          })

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

          -- ── Rust LSP (rust-analyzer) ──────────────────────────
          -- cargo.target é detectado automaticamente pelo workspace:
          --   • se .cargo/config.toml tiver [build] target = "wasm32-*" → usa wasm32
          --   • senão → usa o target nativo (x86_64-unknown-linux-gnu)
          -- Fixar wasm32 aqui quebra completamente projetos nativos (axum,
          -- actix, serviços backend): std::net, tokio::fs, std::io desaparecem
          -- do autocomplete porque não existem no wasm32.
          lspconfig.rust_analyzer.setup({
            capabilities = capabilities,
            settings = {
              ['rust-analyzer'] = {
                checkOnSave = {
                  -- clippy em vez de check: mostra mais warnings úteis
                  -- extraArgs vazios → clippy usa o target do workspace
                  command   = "clippy",
                },
                procMacro  = { enable = true },
                cargo      = {
                  -- SEM target fixo: o analyzer lê o .cargo/config.toml do projeto.
                  -- Para projetos WASM: adicione ao .cargo/config.toml do projeto:
                  --   [build]
                  --   target = "wasm32-unknown-unknown"
                  features  = "all",
                  buildScripts = { enable = true },
                },
                diagnostics = {
                  -- Mostra erros do clippy inline no editor
                  enable = true,
                  experimental = { enable = true },
                },
                inlayHints = {
                  bindingModeHints       = { enable = true },
                  chainingHints          = { enable = true },
                  parameterHints         = { enable = true },
                  typeHints              = { enable = true },
                  closureReturnTypeHints = { enable = "always" },
                },
              },
            },
          })

          -- ── TypeScript / JavaScript LSP ───────────────────────
          lspconfig.ts_ls.setup({
            capabilities = capabilities,
            settings = {
              typescript = {
                inlayHints = {
                  includeInlayParameterNameHints         = 'all',
                  includeInlayFunctionParameterTypeHints = true,
                  includeInlayVariableTypeHints          = true,
                  includeInlayPropertyDeclarationTypeHints = true,
                  includeInlayFunctionLikeReturnTypeHints  = true,
                },
              },
              javascript = {
                inlayHints = {
                  includeInlayParameterNameHints         = 'all',
                  includeInlayFunctionParameterTypeHints = true,
                  includeInlayVariableTypeHints          = true,
                },
              },
            },
          })

          -- ── HTML LSP ──────────────────────────────────────────
          lspconfig.html.setup({
            capabilities = capabilities,
            filetypes    = { 'html', 'htmldjango', 'jinja' },
            init_options = {
              provideFormatter = false,
            },
          })

          -- ── CSS / SCSS LSP ────────────────────────────────────
          lspconfig.cssls.setup({
            capabilities = capabilities,
            settings = {
              css  = { validate = true, lint = { unknownAtRules = "ignore" } },
              scss = { validate = true },
            },
          })

          -- ── JSON LSP ──────────────────────────────────────────
          lspconfig.jsonls.setup({
            capabilities = capabilities,
            settings = {
              json = {
                schemas = require('schemastore').json.schemas(),
                validate = { enable = true },
              },
            },
          })

          -- ── Emmet — expansões HTML/CSS ────────────────────────
          lspconfig.emmet_language_server.setup({
            capabilities = capabilities,
            filetypes = {
              'html', 'css', 'scss', 'javascript', 'javascriptreact',
              'typescript', 'typescriptreact',
            },
          })

          -- ── Tailwind CSS LSP ──────────────────────────────────
          lspconfig.tailwindcss.setup({
            capabilities = capabilities,
            root_dir = require('lspconfig.util').root_pattern(
              'tailwind.config.js', 'tailwind.config.ts',
              'postcss.config.js', 'postcss.config.ts'
            ),
          })

          -- ── ESLint LSP ────────────────────────────────────────
          lspconfig.eslint.setup({
            capabilities = capabilities,
            on_attach = function(_, bufnr)
              vim.api.nvim_create_autocmd('BufWritePre', {
                buffer  = bufnr,
                command = 'EslintFixAll',
              })
            end,
          })

          -- ── Atalhos LSP ───────────────────────────────────────
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
              vim.keymap.set('n', '[d',        vim.diagnostic.goto_prev,    vim.tbl_extend('force', opts, { desc = 'Prev Diagnostic' }))
              vim.keymap.set('n', ']d',        vim.diagnostic.goto_next,    vim.tbl_extend('force', opts, { desc = 'Next Diagnostic' }))
              vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float,   vim.tbl_extend('force', opts, { desc = 'Show Diagnostics' }))
            end,
          })

          local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
          for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
          end
        '';
      }

      # ── Completion ───────────────────────────────────────────
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
              ['<CR>']      = cmp.mapping.confirm({ select = false }),
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

      # ── Telescope ────────────────────────────────────────────
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

          vim.keymap.set('n', '<leader>sf', builtin.find_files,    { desc = 'Search Files' })
          vim.keymap.set('n', '<leader>sg', builtin.live_grep,     { desc = 'Search Grep' })
          vim.keymap.set('n', '<leader>sb', builtin.buffers,       { desc = 'Search Buffers' })
          vim.keymap.set('n', '<leader>sh', builtin.help_tags,     { desc = 'Search Help' })
          vim.keymap.set('n', '<leader>sr', builtin.oldfiles,      { desc = 'Search Recent' })
          vim.keymap.set('n', '<leader>sd', builtin.diagnostics,   { desc = 'Search Diagnostics' })
          vim.keymap.set('n', '<leader>sk', builtin.keymaps,       { desc = 'Search Keymaps' })
          vim.keymap.set('n', '<leader>/',  builtin.current_buffer_fuzzy_find, { desc = 'Search in Buffer' })
          vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = 'Find Files' })
        '';
      }

      # ── Git signs ─────────────────────────────────────────────
      {
        plugin = gitsigns-nvim;
        type   = "lua";
        config = ''
          require('gitsigns').setup({
            signs = {
              add          = { text = '▎' },
              change       = { text = '▎' },
              delete       = { text = '▁' },
              topdelete    = { text = '▔' },
              changedelete = { text = '▎' },
              untracked    = { text = '░' },
            },
            on_attach = function(bufnr)
              local gs = package.loaded.gitsigns
              local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
              end
              map('n', ']h', gs.next_hunk,            { desc = 'Next Hunk' })
              map('n', '[h', gs.prev_hunk,            { desc = 'Prev Hunk' })
              map('n', '<leader>hs', gs.stage_hunk,   { desc = 'Stage Hunk' })
              map('n', '<leader>hr', gs.reset_hunk,   { desc = 'Reset Hunk' })
              map('n', '<leader>hp', gs.preview_hunk, { desc = 'Preview Hunk' })
              map('n', '<leader>hb', function() gs.blame_line({ full = true }) end, { desc = 'Blame Line' })
              map('n', '<leader>hd', gs.diffthis,     { desc = 'Diff This' })
            end,
          })
        '';
      }

      # ── nvim-surround ─────────────────────────────────────────
      {
        plugin = nvim-surround;
        type   = "lua";
        config = ''
          require('nvim-surround').setup()
          -- ysiw"  → envolve palavra com ""
          -- cs"'   → troca "" por ''''
          -- ds"    → remove ""
          -- S" (visual) → envolve seleção
        '';
      }

      # ── nvim-autopairs ────────────────────────────────────────
      {
        plugin = nvim-autopairs;
        type   = "lua";
        config = ''
          local autopairs = require('nvim-autopairs')
          autopairs.setup({
            check_ts = true,
          })
          local cmp_autopairs = require('nvim-autopairs.completion.cmp')
          local cmp = require('cmp')
          cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
        '';
      }

      # ── comment.nvim ──────────────────────────────────────────
      {
        plugin = comment-nvim;
        type   = "lua";
        config = ''
          require('Comment').setup({
            -- gcc  → comenta linha
            -- gc   → comenta seleção visual
            -- gbc  → comenta bloco
            -- gco/gcO/gcA → inserem comentário em posições variadas
          })
        '';
      }

      # ── trouble.nvim ──────────────────────────────────────────
      {
        plugin = trouble-nvim;
        type   = "lua";
        config = ''
          require('trouble').setup({
            modes = {
              diagnostics = {
                auto_open    = false,
                auto_close   = true,
                auto_preview = true,
              },
            },
            icons = {
              error   = " ",
              warning = " ",
              hint    = "󰠠 ",
              info    = " ",
            },
          })
          vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<CR>',
            { desc = 'Toggle Diagnostics (Trouble)' })
          vim.keymap.set('n', '<leader>xb', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>',
            { desc = 'Buffer Diagnostics (Trouble)' })
          vim.keymap.set('n', '<leader>xl', '<cmd>Trouble loclist toggle<CR>',
            { desc = 'Location List (Trouble)' })
          vim.keymap.set('n', '<leader>xq', '<cmd>Trouble qflist toggle<CR>',
            { desc = 'Quickfix List (Trouble)' })
        '';
      }

      # ── conform.nvim — formatação unificada ──────────────────
      {
        plugin = conform-nvim;
        type   = "lua";
        config = ''
          require('conform').setup({
            formatters_by_ft = {
              rust            = { 'rustfmt' },
              javascript      = { 'prettier' },
              typescript      = { 'prettier' },
              javascriptreact = { 'prettier' },
              typescriptreact = { 'prettier' },
              html            = { 'prettier' },
              css             = { 'prettier' },
              scss            = { 'prettier' },
              json            = { 'prettier' },
              markdown        = { 'prettier' },
              yaml            = { 'prettier' },
              nix             = { 'nixpkgs-fmt' },
            },
            format_on_save = {
              timeout_ms   = 500,
              lsp_fallback = true,
            },
          })
          -- Sobrescreve <leader>f do lspconfig
          vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
            require('conform').format({ async = true, lsp_fallback = true })
          end, { desc = 'Format (conform)' })
        '';
      }

      # ── nvim-dap — Debug Adapter Protocol ────────────────────
      # nvim-dap-ui e nvim-nio são dependências, carregam sem config própria
      nvim-dap-ui
      nvim-nio
      {
        plugin = nvim-dap;
        type   = "lua";
        config = ''
          local dap   = require('dap')
          local dapui = require('dapui')

          dapui.setup({
            icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
            layouts = {
              {
                elements = {
                  { id = "scopes",      size = 0.35 },
                  { id = "breakpoints", size = 0.15 },
                  { id = "stacks",      size = 0.30 },
                  { id = "watches",     size = 0.20 },
                },
                size     = 45,
                position = "left",
              },
              {
                elements = {
                  { id = "repl",    size = 0.5 },
                  { id = "console", size = 0.5 },
                },
                size     = 10,
                position = "bottom",
              },
            },
          })

          dap.listeners.after.event_initialized["dapui_config"]  = function() dapui.open() end
          dap.listeners.before.event_terminated["dapui_config"]  = function() dapui.close() end
          dap.listeners.before.event_exited["dapui_config"]      = function() dapui.close() end

          -- ── Adapter codelldb ───────────────────────────────────
          local codelldb_path = vim.fn.exepath('codelldb')
          if codelldb_path ~= "" then
            dap.adapters.codelldb = {
              type = 'server',
              port = "''${port}",
              executable = {
                command = codelldb_path,
                args    = { '--port', "''${port}" },
              },
            }
          else
            -- Fallback: glob no nix store
            dap.adapters.codelldb = {
              type = 'server',
              port = "''${port}",
              executable = {
                command = vim.fn.glob(
                  '/nix/store/*-vscode-extension-vadimcn-vscode-lldb-*/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb'
                ),
                args = { '--port', "''${port}" },
              },
            }
          end

          -- ── Configuração Rust ──────────────────────────────────
          dap.configurations.rust = {
            {
              name    = "Debug binário (cargo build antes)",
              type    = "codelldb",
              request = "launch",
              program = function()
                local crate = vim.fn.fnamemodify(
                  vim.fn.findfile('Cargo.toml', '.;'), ':h:t'
                )
                local default = vim.fn.getcwd() .. '/target/debug/' .. crate
                return vim.fn.input('Binário: ', default, 'file')
              end,
              cwd         = "''${workspaceFolder}",
              stopOnEntry = false,
              initCommands = function()
                local rustc_sysroot = vim.fn.trim(vim.fn.system('rustc --print sysroot'))
                local script_import = 'command script import "'
                  .. rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py"'
                local commands_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_commands'
                local commands = {}
                local file = io.open(commands_file, 'r')
                if file then
                  for line in file:lines() do
                    table.insert(commands, line)
                  end
                  file:close()
                end
                table.insert(commands, 1, script_import)
                return commands
              end,
            },
          }

          dap.configurations.c   = dap.configurations.rust
          dap.configurations.cpp = dap.configurations.rust

          -- ── Keybinds ───────────────────────────────────────────
          local map = vim.keymap.set
          map('n', '<F5>',       dap.continue,          { desc = 'Debug: Continuar / Iniciar' })
          map('n', '<F10>',      dap.step_over,         { desc = 'Debug: Step Over' })
          map('n', '<F11>',      dap.step_into,         { desc = 'Debug: Step Into' })
          map('n', '<F12>',      dap.step_out,          { desc = 'Debug: Step Out' })
          map('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
          map('n', '<leader>dB', function()
            dap.set_breakpoint(vim.fn.input('Condição: '))
          end, { desc = 'Debug: Breakpoint Condicional' })
          map('n', '<leader>dr', dap.repl.open,  { desc = 'Debug: REPL' })
          map('n', '<leader>dl', dap.run_last,   { desc = 'Debug: Repetir último' })
          map('n', '<leader>du', dapui.toggle,   { desc = 'Debug: Toggle UI' })
          map('n', '<leader>dx', dap.terminate,  { desc = 'Debug: Terminar' })

          vim.fn.sign_define('DapBreakpoint',          { text='●', texthl='DiagnosticSignError' })
          vim.fn.sign_define('DapBreakpointCondition', { text='◐', texthl='DiagnosticSignWarn'  })
          vim.fn.sign_define('DapStopped',             { text='▶', texthl='DiagnosticSignInfo'  })
        '';
      }

    ]; # fim plugins

    extraLuaConfig = ''
      vim.g.mapleader      = " "
      vim.g.maplocalleader = " "

      local opt = vim.opt

      opt.number         = true
      opt.relativenumber = true
      opt.cursorline     = true
      opt.signcolumn     = "yes"
      opt.wrap           = false
      opt.scrolloff      = 8
      opt.sidescrolloff  = 8

      opt.tabstop     = 2
      opt.shiftwidth  = 2
      opt.expandtab   = true
      opt.smartindent = true

      opt.ignorecase = true
      opt.smartcase  = true
      opt.hlsearch   = false
      opt.incsearch  = true

      opt.updatetime = 250
      opt.timeoutlen = 400

      opt.clipboard = "unnamedplus"

      opt.termguicolors = true
      opt.background    = "dark"
      opt.showmode      = false

      opt.splitright = true
      opt.splitbelow = true

      local map = vim.keymap.set

      map({ 'n', 'i', 'v' }, '<C-s>', '<cmd>w<CR>', { desc = 'Save' })
      map('n', '<leader>q', '<cmd>q<CR>', { desc = 'Quit' })

      map('n', '<C-h>', '<C-w>h', { desc = 'Move to left split' })
      map('n', '<C-j>', '<C-w>j', { desc = 'Move to lower split' })
      map('n', '<C-k>', '<C-w>k', { desc = 'Move to upper split' })
      map('n', '<C-l>', '<C-w>l', { desc = 'Move to right split' })

      map('n', '<S-l>', '<cmd>bnext<CR>',     { desc = 'Next Buffer' })
      map('n', '<S-h>', '<cmd>bprevious<CR>', { desc = 'Prev Buffer' })
      map('n', '<leader>bd', '<cmd>bd<CR>',   { desc = 'Close Buffer' })

      map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
      map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

      map('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down + center' })
      map('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up + center' })
      map('n', 'n',     'nzzzv',   { desc = 'Next search result + center' })
      map('n', 'N',     'Nzzzv',   { desc = 'Prev search result + center' })

      map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })
      map('n', 'Q', '<nop>')
    '';
  };
}
