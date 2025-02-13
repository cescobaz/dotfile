local M = {}

M.setup = function(capabilities)
  local lspconfig = require("lspconfig")
  lspconfig.lua_ls.setup({
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
  lspconfig.bashls.setup({
    capabilities = capabilities,
  })
  lspconfig.ansiblels.setup({
    capabilities = capabilities,
  })
  lspconfig.clangd.setup {
    capabilities = capabilities,
  }
  lspconfig.hls.setup({
    capabilities = capabilities,
    filetypes = { 'haskell', 'lhaskell', 'cabal' },
  })
  lspconfig.elixirls.setup({
    capabilities = capabilities,
    cmd = { "/opt/homebrew/bin/elixir-ls" },
    elixirLS = {
      dialyzerEnabled = false
    }
  })
  lspconfig.cssls.setup {
    capabilities = capabilities,
  }
  -- lspconfig.tailwindcss.setup({
  --   capabilities = capabilities,
  --   init_options = {
  --     userLanguages = {
  --       eelixir = "html-eex",
  --       elixir = "html-eex",
  --     },
  --   },
  -- })
  -- lspconfig.ts_ls.setup({
  lspconfig.tsserver.setup({
    capabilities = capabilities,
  })
  lspconfig.eslint.setup({
    capabilities = capabilities,
  })
  lspconfig.jsonls.setup({
    capabilities = capabilities,
  })
  lspconfig.pylsp.setup({
    capabilities = capabilities,
  })
  lspconfig.svelte.setup({
    capabilities = capabilities,
    cmd = { "npm", "exec", "svelte-language-server", "--", "--stdio" },
  })
  lspconfig.arduino_language_server.setup({
    capabilities = capabilities,
    cmd = { "arduino-language-server", "-cli-config", "/home/buro/.arduino15/arduino-cli.yaml" },
  })
  lspconfig.terraformls.setup({})
  lspconfig.zls.setup({
    capabilities = capabilities,
  })

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
