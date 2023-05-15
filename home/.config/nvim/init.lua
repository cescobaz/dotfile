vim.cmd('map <Space> <Leader>')
vim.g.mapleader = ' '
vim.o.number = true
vim.o.cursorline = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
-- show not visible chars
vim.o.listchars = 'eol:$,tab:>·,trail:~,extends:>,precedes:<'
vim.o.list = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "RRethy/nvim-base16",
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build =
    'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
  },
  { 'nvim-telescope/telescope.nvim',   dependencies = { 'nvim-lua/plenary.nvim' } },
  "tpope/vim-fugitive",
  { "nvim-treesitter/nvim-treesitter", cmd = "TSUpdate" },
  'cescobaz/vim-snippets',
  { "L3MON4D3/LuaSnip",          build = "make install_jsregexp" },
  'saadparwaiz1/cmp_luasnip',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/nvim-cmp',
  "neovim/nvim-lspconfig",
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
  'mfussenegger/nvim-dap',
})

require("user.base16").setup()
require("user.telescope").setup()
require("user.treesitter").setup()
require("user.luasnip").setup()
local capabilities = require('user.cmp').setup()

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<Leader>q', vim.diagnostic.setloclist)

require("user.lspconfig").setup(capabilities)
require("user.lualine").setup()
require("user.dap").setup()
