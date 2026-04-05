require("nvim-treesitter").setup({})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'elixir', 'lua' },
  callback = function()
    vim.treesitter.start()
  end,
})
