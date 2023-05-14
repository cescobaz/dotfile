vim.cmd('map <Space> <Leader>')
vim.g.mapleader = ' '
vim.o.number = true
vim.o.cursorline = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2

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
})

if not (vim.env.BASE16_THEME == nil) then
  vim.g.base16colorspace = 256
  local command = string.format("colorscheme base16-%s", vim.env.BASE16_THEME)
  vim.cmd(command)
end

local actions = require('telescope.actions')
require('telescope').setup({
  extensions = {
    fzf = {
      fuzzy = true,                   -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true,    -- override the file sorter
      case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
    },
  },
  defaults = {
    mappings = {
      i = {
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
      },
    },
    layout_strategy = 'center',
    layout_config = {
      vertical = { width = 0.9, height = 0.9, anchor = 'CENTER' },
    },
  },
  pickers = {
    builtin = {
      theme = "dropdown",
    },
    find_files = {
      theme = "dropdown",
    },
    live_grep = {
      theme = "dropdown",
    },
    buffers = {
      theme = "dropdown",
    },
    current_buffer_fuzzy_find = {
      theme = "dropdown",
    },
    command_history = {
      theme = "dropdown",
    },
    help_tags = {
      theme = "dropdown",
    },
  },
})
require('telescope').load_extension('fzf')

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<Leader>t', builtin.builtin, {})
vim.keymap.set('n', '<Leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<Leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<Leader>fF', builtin.live_grep, {})
vim.keymap.set('n', '<Leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<Leader>fB', builtin.current_buffer_fuzzy_find, {})
vim.keymap.set('n', '<Leader>fc', builtin.command_history, {})
vim.keymap.set('n', '<Leader>fh', builtin.help_tags, {})

require("nvim-treesitter.configs").setup({
  ensure_installed = { "elixir", "heex", "lua", "vim", "vimdoc", "html" },
  highlight = { enable = true },
  additional_vcc_regex_highlighting = false,
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<Leader>s",
      node_incremental = "<Leader>s",
      scope_incremental = "<Leader>S",
      node_decremental = "<Leader>-s",
    },
  },
})

-- LuaSnip
local luasnip = require('luasnip')
local snippets_path = vim.fn.stdpath('data') .. "/lazy/vim-snippets/snippets"
require("luasnip.loaders.from_snipmate").lazy_load({ paths = snippets_path })

vim.keymap.set({ 'i', 's' }, '<C-j>', '<Plug>luasnip-expand-or-jump')
vim.keymap.set({ 'i', 's' }, '<C-k>', function() luasnip.jump(-1) end, {})

-- nvim-cmp
local cmp = require 'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
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
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<Leader>q', vim.diagnostic.setloclist)

local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup({
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
    },
  },
})
require('lspconfig').bashls.setup({})
lspconfig.ansiblels.setup({})
lspconfig.tailwindcss.setup({
  init_options = {
    userLanguages = {
      eelixir = "html-eex",
      elixir = "html-eex",
    },
  },
})
lspconfig.elixirls.setup({
  capabilities = capabilities,
  cmd = { "elixir-ls" }
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
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

require("lualine").setup({
  options = {
    icons_enabled = true,
    section_separators = '',
    component_separators = '',
  },
  sections = {
    lualine_a = {
      {
        'mode',
        color = 'Search',
      },
    },
    lualine_b = {},
    lualine_c = { { 'filename', path = 1 }, 'diagnostics' },
    lualine_z = { { 'location', color = 'StatusLine' } }
  },
  inactive_sections = {
    lualine_c = { { 'filename', path = 1, color = 'Search' }, 'diagnostics' },
  },
})
