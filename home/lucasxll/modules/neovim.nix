{ pkgs, ... }:

{
  programs.neovim = {
    enable        = true;
    defaultEditor = true;
    viAlias       = true;
    vimAlias      = true;

    extraPackages = with pkgs; [
      nil pyright lua-language-server
      rust-analyzer rustfmt
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      nodePackages."@tailwindcss/language-server"
      emmet-language-server
      nodePackages.prettier
      nodePackages.eslint
      lldb vscode-extensions.vadimcn.vscode-lldb
      ripgrep fd
    ];

    plugins = with pkgs.vimPlugins; [
      plenary-nvim

      {
        plugin = tokyonight-nvim;
        type   = "lua";
        config = ''
          require('tokyonight').setup({
            style = "night", transparent = true, terminal_colors = true,
            styles = { comments = { italic = true }, keywords = { italic = true }, functions = {}, variables = {} },
          })
          vim.cmd("colorscheme tokyonight-night")
        '';
      }

      nvim-web-devicons
      {
        plugin = lualine-nvim;
        type   = "lua";
        config = ''
          require('lualine').setup({
            options = {
              theme = 'tokyonight',
              section_separators   = { left = "", right = "" },
              component_separators = { left = "", right = "" },
              globalstatus = true,
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

      {
        plugin = which-key-nvim;
        type   = "lua";
        config = "require('which-key').setup({ delay = 400 })";
      }

      {
        plugin = (nvim-treesitter.withPlugins (p: with p; [
          nix bash python lua
          javascript typescript json yaml toml
          markdown markdown_inline
          html css c cpp rust
          vim vimdoc query
        ]));
        type   = "lua";
        config = ''
          require('nvim-treesitter.configs').setup({
            highlight = {
              enable  = true,
              disable = function(lang, buf)
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > 100 * 1024 then return true end
              end,
            },
            indent = { enable = true },
          })
        '';
      }

      SchemaStore-nvim

      {
        plugin = nvim-lspconfig;
        type   = "lua";
        config = ''
          local lsp  = require('lspconfig')
          local caps = require('cmp_nvim_lsp').default_capabilities()

          lsp.nil_ls.setup({
            capabilities = caps,
            settings = { ['nil'] = { formatting = { command = { "nixpkgs-fmt" } }, nix = { flake = { autoEvalInputs = false } } } },
          })
          lsp.pyright.setup({
            capabilities = caps,
            settings = { python = { analysis = { typeCheckingMode = "basic", autoSearchPaths = true, useLibraryCodeForTypes = true } } },
          })
          lsp.lua_ls.setup({
            capabilities = caps,
            settings = { Lua = {
              runtime    = { version = 'LuaJIT' },
              workspace  = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file("", true) },
              telemetry  = { enable = false },
              diagnostics = { globals = { 'vim', 'wezterm' } },
            }},
          })

          -- cargo.target detectado pelo workspace (.cargo/config.toml).
          -- Sem target fixo: fixar wasm32 aqui quebra projetos nativos (axum, actix).
          lsp.rust_analyzer.setup({
            capabilities = caps,
            settings = { ['rust-analyzer'] = {
              checkOnSave  = { command = "clippy" },
              procMacro    = { enable = true },
              cargo        = { features = "all", buildScripts = { enable = true } },
              diagnostics  = { enable = true, experimental = { enable = true } },
              inlayHints   = {
                bindingModeHints = { enable = true }, chainingHints = { enable = true },
                parameterHints   = { enable = true }, typeHints     = { enable = true },
                closureReturnTypeHints = { enable = "always" },
              },
            }},
          })

          lsp.ts_ls.setup({
            capabilities = caps,
            settings = {
              typescript  = { inlayHints = { includeInlayParameterNameHints = 'all', includeInlayFunctionParameterTypeHints = true, includeInlayVariableTypeHints = true, includeInlayPropertyDeclarationTypeHints = true, includeInlayFunctionLikeReturnTypeHints = true } },
              javascript  = { inlayHints = { includeInlayParameterNameHints = 'all', includeInlayFunctionParameterTypeHints = true, includeInlayVariableTypeHints = true } },
            },
          })
          lsp.html.setup({ capabilities = caps, filetypes = { 'html', 'htmldjango', 'jinja' }, init_options = { provideFormatter = false } })
          lsp.cssls.setup({ capabilities = caps, settings = { css = { validate = true, lint = { unknownAtRules = "ignore" } }, scss = { validate = true } } })
          lsp.jsonls.setup({ capabilities = caps, settings = { json = { schemas = require('schemastore').json.schemas(), validate = { enable = true } } } })
          lsp.emmet_language_server.setup({ capabilities = caps, filetypes = { 'html', 'css', 'scss', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' } })
          lsp.tailwindcss.setup({ capabilities = caps, root_dir = require('lspconfig.util').root_pattern('tailwind.config.js', 'tailwind.config.ts', 'postcss.config.js', 'postcss.config.ts') })
          lsp.eslint.setup({ capabilities = caps, on_attach = function(_, bufnr)
            vim.api.nvim_create_autocmd('BufWritePre', { buffer = bufnr, command = 'EslintFixAll' })
          end })

          vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('LspKeymaps', {}),
            callback = function(ev)
              local o = { buffer = ev.buf, silent = true }
              local k = vim.keymap.set
              k('n', 'gd',         vim.lsp.buf.definition,     vim.tbl_extend('force', o, { desc = 'Definition' }))
              k('n', 'gD',         vim.lsp.buf.declaration,    vim.tbl_extend('force', o, { desc = 'Declaration' }))
              k('n', 'gr',         vim.lsp.buf.references,     vim.tbl_extend('force', o, { desc = 'References' }))
              k('n', 'gi',         vim.lsp.buf.implementation, vim.tbl_extend('force', o, { desc = 'Implementation' }))
              k('n', 'K',          vim.lsp.buf.hover,          vim.tbl_extend('force', o, { desc = 'Hover' }))
              k('n', '<leader>rn', vim.lsp.buf.rename,         vim.tbl_extend('force', o, { desc = 'Rename' }))
              k('n', '<leader>ca', vim.lsp.buf.code_action,    vim.tbl_extend('force', o, { desc = 'Code Action' }))
              k('n', '[d',         vim.diagnostic.goto_prev,   vim.tbl_extend('force', o, { desc = 'Prev Diagnostic' }))
              k('n', ']d',         vim.diagnostic.goto_next,   vim.tbl_extend('force', o, { desc = 'Next Diagnostic' }))
              k('n', '<leader>e',  vim.diagnostic.open_float,  vim.tbl_extend('force', o, { desc = 'Show Diagnostics' }))
            end,
          })

          for type, icon in pairs({ Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
          end
        '';
      }

      luasnip cmp_luasnip cmp-nvim-lsp cmp-buffer cmp-path
      {
        plugin = nvim-cmp;
        type   = "lua";
        config = ''
          local cmp     = require('cmp')
          local luasnip = require('luasnip')

          cmp.setup({
            snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
            mapping = cmp.mapping.preset.insert({
              ['<C-b>']     = cmp.mapping.scroll_docs(-4),
              ['<C-f>']     = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<C-e>']     = cmp.mapping.abort(),
              ['<CR>']      = cmp.mapping.confirm({ select = false }),
              ['<Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
                else fallback() end
              end, { 'i', 's' }),
              ['<S-Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then luasnip.jump(-1)
                else fallback() end
              end, { 'i', 's' }),
            }),
            sources = cmp.config.sources(
              { { name = 'nvim_lsp' }, { name = 'luasnip' }, { name = 'path' } },
              { { name = 'buffer' } }
            ),
            formatting = {
              format = function(entry, item)
                item.menu = ({ nvim_lsp = "󰒋", luasnip = "", buffer = "󰦨", path = "󰉋" })[entry.source.name]
                return item
              end,
            },
          })
        '';
      }

      telescope-fzf-native-nvim
      {
        plugin = telescope-nvim;
        type   = "lua";
        config = ''
          local t   = require('telescope')
          local b   = require('telescope.builtin')
          local act = require('telescope.actions')

          t.setup({
            defaults = {
              mappings = { i = { ['<C-k>'] = act.move_selection_previous, ['<C-j>'] = act.move_selection_next, ['<Esc>'] = act.close } },
              find_command      = { 'fd', '--type', 'f', '--hidden', '--exclude', '.git' },
              vimgrep_arguments = { 'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case', '--hidden', '--glob=!.git/' },
            },
            extensions = { fzf = { fuzzy = true, override_generic_sorter = true, override_file_sorter = true, case_mode = "smart_case" } },
          })
          t.load_extension('fzf')

          local k = vim.keymap.set
          k('n', '<leader>sf', b.find_files,                    { desc = 'Search Files' })
          k('n', '<leader>sg', b.live_grep,                     { desc = 'Search Grep' })
          k('n', '<leader>sb', b.buffers,                       { desc = 'Search Buffers' })
          k('n', '<leader>sh', b.help_tags,                     { desc = 'Search Help' })
          k('n', '<leader>sr', b.oldfiles,                      { desc = 'Search Recent' })
          k('n', '<leader>sd', b.diagnostics,                   { desc = 'Search Diagnostics' })
          k('n', '<leader>sk', b.keymaps,                       { desc = 'Search Keymaps' })
          k('n', '<leader>/',  b.current_buffer_fuzzy_find,     { desc = 'Search in Buffer' })
          k('n', '<C-p>',      b.find_files,                    { desc = 'Find Files' })
        '';
      }

      {
        plugin = gitsigns-nvim;
        type   = "lua";
        config = ''
          require('gitsigns').setup({
            signs = { add = { text = '▎' }, change = { text = '▎' }, delete = { text = '▁' }, topdelete = { text = '▔' }, changedelete = { text = '▎' }, untracked = { text = '░' } },
            on_attach = function(bufnr)
              local gs = package.loaded.gitsigns
              local function m(mode, l, r, opts) opts = opts or {}; opts.buffer = bufnr; vim.keymap.set(mode, l, r, opts) end
              m('n', ']h', gs.next_hunk,            { desc = 'Next Hunk' })
              m('n', '[h', gs.prev_hunk,            { desc = 'Prev Hunk' })
              m('n', '<leader>hs', gs.stage_hunk,   { desc = 'Stage Hunk' })
              m('n', '<leader>hr', gs.reset_hunk,   { desc = 'Reset Hunk' })
              m('n', '<leader>hp', gs.preview_hunk, { desc = 'Preview Hunk' })
              m('n', '<leader>hb', function() gs.blame_line({ full = true }) end, { desc = 'Blame Line' })
              m('n', '<leader>hd', gs.diffthis,     { desc = 'Diff This' })
            end,
          })
        '';
      }

      { plugin = nvim-surround; type = "lua"; config = "require('nvim-surround').setup()"; }

      {
        plugin = nvim-autopairs;
        type   = "lua";
        config = ''
          local ap = require('nvim-autopairs')
          ap.setup({ check_ts = true })
          require('nvim-autopairs.completion.cmp').on_confirm_done()
          require('cmp').event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done())
        '';
      }

      { plugin = comment-nvim; type = "lua"; config = "require('Comment').setup()"; }

      {
        plugin = trouble-nvim;
        type   = "lua";
        config = ''
          require('trouble').setup({
            modes = { diagnostics = { auto_open = false, auto_close = true, auto_preview = true } },
            icons = { error = " ", warning = " ", hint = "󰠠 ", info = " " },
          })
          local k = vim.keymap.set
          k('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<CR>',            { desc = 'Diagnostics' })
          k('n', '<leader>xb', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', { desc = 'Buffer Diagnostics' })
          k('n', '<leader>xl', '<cmd>Trouble loclist toggle<CR>',                { desc = 'Location List' })
          k('n', '<leader>xq', '<cmd>Trouble qflist toggle<CR>',                 { desc = 'Quickfix' })
        '';
      }

      {
        plugin = conform-nvim;
        type   = "lua";
        config = ''
          require('conform').setup({
            formatters_by_ft = {
              rust = { 'rustfmt' },
              nix  = { 'nixpkgs-fmt' },
              javascript = { 'prettier' }, typescript      = { 'prettier' },
              javascriptreact = { 'prettier' }, typescriptreact = { 'prettier' },
              html = { 'prettier' }, css = { 'prettier' }, scss = { 'prettier' },
              json = { 'prettier' }, markdown = { 'prettier' }, yaml = { 'prettier' },
            },
            format_on_save = { timeout_ms = 500, lsp_fallback = true },
          })
          vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
            require('conform').format({ async = true, lsp_fallback = true })
          end, { desc = 'Format' })
        '';
      }

      nvim-dap-ui nvim-nio
      {
        plugin = nvim-dap;
        type   = "lua";
        config = ''
          local dap   = require('dap')
          local dapui = require('dapui')

          dapui.setup({
            icons   = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
            layouts = {
              { elements = { { id = "scopes", size = 0.35 }, { id = "breakpoints", size = 0.15 }, { id = "stacks", size = 0.30 }, { id = "watches", size = 0.20 } }, size = 45, position = "left" },
              { elements = { { id = "repl", size = 0.5 }, { id = "console", size = 0.5 } }, size = 10, position = "bottom" },
            },
          })

          dap.listeners.after.event_initialized["dapui_config"]  = function() dapui.open() end
          dap.listeners.before.event_terminated["dapui_config"]  = function() dapui.close() end
          dap.listeners.before.event_exited["dapui_config"]      = function() dapui.close() end

          local codelldb = vim.fn.exepath('codelldb')
          if codelldb == "" then
            codelldb = vim.fn.glob('/nix/store/*-vscode-extension-vadimcn-vscode-lldb-*/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb')
          end
          dap.adapters.codelldb = { type = 'server', port = "''${port}", executable = { command = codelldb, args = { '--port', "''${port}" } } }

          dap.configurations.rust = {{
            name    = "Debug binário",
            type    = "codelldb",
            request = "launch",
            program = function()
              local crate = vim.fn.fnamemodify(vim.fn.findfile('Cargo.toml', '.;'), ':h:t')
              return vim.fn.input('Binário: ', vim.fn.getcwd() .. '/target/debug/' .. crate, 'file')
            end,
            cwd         = "''${workspaceFolder}",
            stopOnEntry = false,
            initCommands = function()
              local root     = vim.fn.trim(vim.fn.system('rustc --print sysroot'))
              local cmds     = {}
              local f        = io.open(root .. '/lib/rustlib/etc/lldb_commands', 'r')
              if f then for line in f:lines() do table.insert(cmds, line) end; f:close() end
              table.insert(cmds, 1, 'command script import "' .. root .. '/lib/rustlib/etc/lldb_lookup.py"')
              return cmds
            end,
          }}
          dap.configurations.c   = dap.configurations.rust
          dap.configurations.cpp = dap.configurations.rust

          local k = vim.keymap.set
          k('n', '<F5>',       dap.continue,          { desc = 'Debug: Continue' })
          k('n', '<F10>',      dap.step_over,         { desc = 'Debug: Step Over' })
          k('n', '<F11>',      dap.step_into,         { desc = 'Debug: Step Into' })
          k('n', '<F12>',      dap.step_out,          { desc = 'Debug: Step Out' })
          k('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Debug: Breakpoint' })
          k('n', '<leader>dB', function() dap.set_breakpoint(vim.fn.input('Condição: ')) end, { desc = 'Debug: Cond Breakpoint' })
          k('n', '<leader>dr', dap.repl.open,  { desc = 'Debug: REPL' })
          k('n', '<leader>dl', dap.run_last,   { desc = 'Debug: Run Last' })
          k('n', '<leader>du', dapui.toggle,   { desc = 'Debug: UI' })
          k('n', '<leader>dx', dap.terminate,  { desc = 'Debug: Terminate' })

          vim.fn.sign_define('DapBreakpoint',          { text = '●', texthl = 'DiagnosticSignError' })
          vim.fn.sign_define('DapBreakpointCondition', { text = '◐', texthl = 'DiagnosticSignWarn'  })
          vim.fn.sign_define('DapStopped',             { text = '▶', texthl = 'DiagnosticSignInfo'  })
        '';
      }

    ];

    extraLuaConfig = ''
      vim.g.mapleader      = " "
      vim.g.maplocalleader = " "

      local opt = vim.opt
      opt.number = true; opt.relativenumber = true; opt.cursorline = true; opt.signcolumn = "yes"
      opt.wrap = false; opt.scrolloff = 8; opt.sidescrolloff = 8
      opt.tabstop = 2; opt.shiftwidth = 2; opt.expandtab = true; opt.smartindent = true
      opt.ignorecase = true; opt.smartcase = true; opt.hlsearch = false; opt.incsearch = true
      opt.updatetime = 250; opt.timeoutlen = 400
      opt.clipboard = "unnamedplus"
      opt.termguicolors = true; opt.background = "dark"; opt.showmode = false
      opt.splitright = true; opt.splitbelow = true

      local k = vim.keymap.set
      k({ 'n', 'i', 'v' }, '<C-s>', '<cmd>w<CR>',        { desc = 'Save' })
      k('n', '<leader>q',   '<cmd>q<CR>',                 { desc = 'Quit' })
      k('n', '<C-h>', '<C-w>h', { desc = 'Left split' })
      k('n', '<C-j>', '<C-w>j', { desc = 'Lower split' })
      k('n', '<C-k>', '<C-w>k', { desc = 'Upper split' })
      k('n', '<C-l>', '<C-w>l', { desc = 'Right split' })
      k('n', '<S-l>', '<cmd>bnext<CR>',     { desc = 'Next Buffer' })
      k('n', '<S-h>', '<cmd>bprevious<CR>', { desc = 'Prev Buffer' })
      k('n', '<leader>bd', '<cmd>bd<CR>',   { desc = 'Close Buffer' })
      k('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move down' })
      k('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move up' })
      k('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down' })
      k('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up' })
      k('n', 'n', 'nzzzv', { desc = 'Next result' })
      k('n', 'N', 'Nzzzv', { desc = 'Prev result' })
      k('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear highlight' })
      k('n', 'Q', '<nop>')
    '';
  };
}
