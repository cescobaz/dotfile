vim.cmd('map <Space> <Leader>')
vim.g.mapleader = ' '
vim.o.number = true
vim.o.relativenumber = false
vim.o.cursorline = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.scrolloff = 8
-- show not visible chars
vim.o.listchars = 'eol:$,tab:>·,trail:~,extends:>,precedes:<'
vim.o.list = true

-- move selection up and down
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y')
vim.keymap.set({ 'n', 'v' }, '<leader>Y', '"+Y')
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p')

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<Leader>q', vim.diagnostic.setloclist)

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('user.lazy')

require('user.base16')
require('user.telescope')
require('user.treesitter')
require('user.luasnip')
local capabilities = require('user.cmp')

require('user.lspconfig').setup(capabilities)
require('user.lualine')
require('user.hop')
-- require('user.dap').setup()
-- require('user.codeium')
-- require('user.llm').setup()
-- require('user.tabnine').setup()
