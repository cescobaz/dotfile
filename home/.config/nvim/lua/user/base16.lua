local M = {}

M.setup = function()
  if not (vim.env.BASE16_THEME == nil) then
    vim.g.base16colorspace = 256
    local command = string.format("colorscheme base16-%s", vim.env.BASE16_THEME)
    vim.cmd(command)
  end
end

return M
