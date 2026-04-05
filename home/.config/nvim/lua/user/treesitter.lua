require("nvim-treesitter").setup({})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'elixir', 'lua' },
  callback = function()
    vim.notify('treesitter: starting for filetype ' .. vim.bo.filetype, vim.log.levels.INFO)
    vim.treesitter.start()
  end,
})
