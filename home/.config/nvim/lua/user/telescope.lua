local actions = require('telescope.actions')
local telescopeConfig = require("telescope.config")
-- Clone the default Telescope configuration
local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }
-- I want to search in hidden/dot files.
table.insert(vimgrep_arguments, "--hidden")
-- I don't want to search in the `.git` directory.
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")

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
    vimgrep_arguments = vimgrep_arguments,
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
      find_command = { "fd", "--hidden", "--ignore", "--type", "f", "--glob", "--exclude", "**/.git/**" },
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
vim.keymap.set('n', '<Leader>fp', builtin.find_files, {})
vim.keymap.set('n', '<Leader>gp', builtin.live_grep, {})
vim.keymap.set('n', '<Leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<Leader>gb', builtin.current_buffer_fuzzy_find, {})
vim.keymap.set('n', '<Leader>fc', builtin.command_history, {})
vim.keymap.set('n', '<Leader>h', builtin.help_tags, {})
