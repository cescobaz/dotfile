require("nvim-treesitter").setup({})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'elixir', 'heex', 'lua', 'typescript', 'javascript', 'json' },
  callback = function()
    vim.treesitter.start()
  end,
})
