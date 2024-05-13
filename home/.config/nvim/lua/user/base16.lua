vim.cmd("set termguicolors")
if not (vim.env.BASE16_THEME == nil) then
  -- vim.g.base16colorspace = 256
  local command = string.format("colorscheme base16-%s", vim.env.BASE16_THEME)
  vim.cmd(command)
else
  -- vim.cmd("colorscheme base16-woodland")
  vim.cmd("colorscheme slate")
end

-- copied from woodland theme (colors directory)
local gui00 = "#231e18"
local gui01 = "#302b25"
local gui02 = "#48413a"
local gui03 = "#9d8b70"
local gui04 = "#b4a490"
local gui05 = "#cabcb1"
local gui06 = "#d7c8bc"
local gui07 = "#e4d4c8"
local gui08 = "#d35c5c"
local gui09 = "#ca7f32"
local gui0A = "#e0ac16"
local gui0B = "#b7ba53"
local gui0C = "#6eb958"
local gui0D = "#88a4d3"
local gui0E = "#bb90e2"
local gui0F = "#b49368"

local cterm00 = 0
local cterm03 = 8
local cterm05 = 7
local cterm07 = 15
local cterm08 = 1
local cterm0A = 3
local cterm0B = 2
local cterm0C = 6
local cterm0D = 4
local cterm0E = 5
local cterm01 = 10
local cterm02 = 11
local cterm04 = 12
local cterm06 = 13
local cterm09 = 9
local cterm0F = 14

vim.api.nvim_set_hl(0, 'Special', { fg = gui0A, ctermfg = cterm0A })
vim.api.nvim_set_hl(0, 'Keyword', { fg = gui0A, ctermfg = cterm0A })
vim.api.nvim_set_hl(0, 'Operator', { fg = gui0A, ctermfg = cterm0A })
vim.api.nvim_set_hl(0, 'Identifier', { fg = gui09, ctermfg = cterm09 })
vim.api.nvim_set_hl(0, 'Type', { fg = gui0C, ctermfg = cterm0C })
vim.api.nvim_set_hl(0, 'Structure', { fg = gui0C, ctermfg = cterm0C })
vim.api.nvim_set_hl(0, 'Function', { fg = gui0B, ctermfg = cterm0B })
vim.api.nvim_set_hl(0, 'String', { fg = gui08, ctermfg = cterm08 })
vim.api.nvim_set_hl(0, 'NonText', { fg = gui02, ctermfg = cterm02 })

vim.api.nvim_set_hl(0, 'Normal', { fg = gui05, ctermfg = cterm05 })
vim.api.nvim_set_hl(0, 'Comment', { fg = gui03, ctermfg = cterm03 })
vim.api.nvim_set_hl(0, 'Ingnore', { fg = gui03, ctermfg = cterm03 })

-- vim.api.nvim_set_hl(0, 'Title', { fg = gui08, ctermfg = cterm08 })
-- vim.api.nvim_set_hl(0, 'Constant', { fg = gui08, ctermfg = cterm08 })
-- vim.api.nvim_set_hl(0, 'TooLong', { fg = gui08, ctermfg = cterm08 })
-- vim.api.nvim_set_hl(0, 'None', { fg = gui08, ctermfg = cterm08 })
-- vim.api.nvim_set_hl(0, 'Noise', { fg = gui08, ctermfg = cterm08 })
-- vim.api.nvim_set_hl(0, 'Method', { fg = gui08, ctermfg = cterm08 })
-- vim.api.nvim_set_hl(0, 'Ingnore', { fg = gui08, ctermfg = cterm08 })
-- vim.api.nvim_set_hl(0, 'SpecialKey', { fg = gui08, ctermfg = cterm08 })
-- vim.api.nvim_set_hl(0, 'SpecialChar', { fg = gui08, ctermfg = cterm08 })
-- vim.api.nvim_set_hl(0, 'Tag', { fg = gui08, ctermfg = cterm08 })
-- vim.api.nvim_set_hl(0, 'Typedef', { fg = gui08, ctermfg = cterm08 })
-- vim.api.nvim_set_hl(0, 'Delimiter', { fg = gui08, ctermfg = cterm08 })
-- vim.api.nvim_set_hl(0, 'Conceal', { fg = gui08, ctermfg = cterm08 })
-- vim.api.nvim_set_hl(0, 'Struct', { fg = gui08, ctermfg = cterm07 })
