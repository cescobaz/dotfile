require("oil").setup({
  -- Id is automatically added at the beginning, and name at the end
  -- See :help oil-columns
  columns = {
    "icon",
    "permissions",
    "size",
    "mtime",
  },
  view_options = {
    -- Show files and directories that start with "."
    show_hidden = true,
  },
})
