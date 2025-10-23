local M = {}

M.setup = function(capabilities)
  vim.lsp.config('lua_ls', {
    capabilities = capabilities,
    settings = {
      Lua = {
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { 'vim' },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
        },
      },
    },
  })
  vim.lsp.enable('lua_ls')
  vim.lsp.config('bashls', {
    capabilities = capabilities,
  })
  vim.lsp.enable('bashls')
  vim.lsp.config('ansiblels', {
    capabilities = capabilities,
  })
  vim.lsp.enable('ansiblels')
  vim.lsp.config('clangd', {
    capabilities = capabilities,
  })
  vim.lsp.enable('clangd')
  vim.lsp.config('hls', {
    capabilities = capabilities,
    filetypes = { 'haskell', 'lhaskell', 'cabal' },
  })
  vim.lsp.enable('hls')
  vim.lsp.config('elixirls', {
    capabilities = capabilities,
    cmd = { "elixir-ls" },
    elixirLS = {
      dialyzerEnabled = false
    }
  })
  vim.lsp.enable('elixirls')
  vim.lsp.config('cssls', {
    capabilities = capabilities,
  })
  vim.lsp.enable('cssls')
  vim.lsp.config('tailwindcss', {
    capabilities = capabilities,
    init_options = {
      userLanguages = {
        eelixir = "html-eex",
        elixir = "html-eex",
      },
    },
  })
  -- vim.lsp.enable('tailwindcss')
  vim.lsp.config('ts_ls', {
    capabilities = capabilities,
  })
  vim.lsp.enable('ts_ls')
  vim.lsp.config('eslint', {
    capabilities = capabilities,
  })
  vim.lsp.enable('eslint')
  vim.lsp.config('jsonls', {
    capabilities = capabilities,
  })
  vim.lsp.enable('jsonls')
  vim.lsp.config('pylsp', {
    capabilities = capabilities,
  })
  vim.lsp.enable('pylsp')
  vim.lsp.config('svelte', {
    capabilities = capabilities,
    cmd = { "npm", "exec", "svelte-language-server", "--", "--stdio" },
  })
  vim.lsp.enable('svelte')
  vim.lsp.config('arduino_language_server', {
    capabilities = capabilities,
    cmd = { "arduino-language-server", "-cli-config", "/home/buro/.arduino15/arduino-cli.yaml" },
  })
  vim.lsp.enable('arduino_language_server')
  vim.lsp.config('terraformls', {})
  vim.lsp.enable('terraformls')
  vim.lsp.config('zls', {
    capabilities = capabilities,
  })
  vim.lsp.enable('zls')

  -- Use LspAttach autocommand to only map the following keys
  -- after the language server attaches to the current buffer
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
      -- Enable completion triggered by <c-x><c-o>
      vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

      -- Buffer local mappings.
      -- See `:help vim.lsp.*` for documentation on any of the below functions
      local opts = { buffer = ev.buf }
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
      vim.keymap.set('n', '<Leader>wa', vim.lsp.buf.add_workspace_folder, opts)
      vim.keymap.set('n', '<Leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
      vim.keymap.set('n', '<Leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, opts)
      vim.keymap.set('n', '<Leader>D', vim.lsp.buf.type_definition, opts)
      vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, opts)
      vim.keymap.set({ 'n', 'v' }, '<Leader>ca', vim.lsp.buf.code_action, opts)
      vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references theme=dropdown<cr>')
      --vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      vim.keymap.set('n', '<Leader>l', function()
        if vim.fn.exists(':EslintFixAll') > 0
        then
          vim.cmd('EslintFixAll')
          print('EslintFixAll')
        else
          vim.lsp.buf.format { async = false }
        end
      end, opts)
    end,
  })
end

return M
