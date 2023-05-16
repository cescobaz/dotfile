  require("lualine").setup({
    options = {
      theme = {
        normal = { c = 'Pmenu' },
        inactive = { c = 'StatusLineNC' },
      },
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
      lualine_c = { { 'filename', path = 1 },  'diagnostics' },
      lualine_z = { { 'location', color = 'Pmenu' } }
    },
    inactive_sections = {
      lualine_c = { { 'filename', path = 1, color = 'Todo' }, 'diagnostics' },
    },
  })
