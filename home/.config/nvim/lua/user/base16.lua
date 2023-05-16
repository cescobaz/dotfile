if not (vim.env.BASE16_THEME == nil) then
  vim.cmd("set termguicolors")
  vim.g.base16colorspace = 256
  local command = string.format("colorscheme base16-%s", vim.env.BASE16_THEME)
  vim.cmd(command)
end
