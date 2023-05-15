local M = {}

M.setup = function()
  local luasnip = require('luasnip')
  local snippets_path = vim.fn.stdpath('data') .. "/lazy/vim-snippets/snippets"
  require("luasnip.loaders.from_snipmate").lazy_load({ paths = snippets_path })

  vim.keymap.set({ 'i', 's' }, '<C-j>', '<Plug>luasnip-expand-or-jump')
  vim.keymap.set({ 'i', 's' }, '<C-k>', function() luasnip.jump(-1) end, {})
end

return M
