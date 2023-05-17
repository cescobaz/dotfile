require("nvim-treesitter.configs").setup({
  ensure_installed = { "bash", "javascript", "c", "elixir", "heex", "lua", "vim", "vimdoc", "html" },
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
