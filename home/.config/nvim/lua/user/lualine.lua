local M = {}

M.setup = function()
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
end

return M
