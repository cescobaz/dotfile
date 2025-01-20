vim.api.nvim_create_user_command(
  "BCommits",
  ":Telescope git_bcommits", -- string or Lua function
  {}
)
