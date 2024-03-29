local luasnip = require("luasnip")
local cmp = require 'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      if luasnip then
        luasnip.lsp_expand(args.body)
      end
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.open_docs(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.complete(),
    ['<C-a>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ['<C-j>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer', option = { get_bufnrs = function() return vim.api.nvim_list_bufs() end } },
    { name = 'path' },
  })
})

-- issue about cmdline https://github.com/hrsh7th/nvim-cmp/issues/740
-- linked issue https://github.com/neovim/neovim/issues/17098

-- Set up lspconfig.
return require('cmp_nvim_lsp').default_capabilities()
