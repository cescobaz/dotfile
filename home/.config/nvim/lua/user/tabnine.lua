local M = {}

M.setup = function()
  require('tabnine').setup({
    disable_auto_comment = true,
    accept_keymap = "<Tab>",
    dismiss_keymap = "<C-[>",
    debounce_ms = 800,
    suggestion_color = { gui = "#808080", cterm = 244 },
    exclude_filetypes = { "TelescopePrompt", "NvimTree" },
    log_file_path = nil, -- absolute path to Tabnine log file
    ignore_certificate_errors = false,
  })

  vim.keymap.set("i", "<Tab>", function()
    if require("tabnine.keymaps").has_suggestion() then
      return require("tabnine.keymaps").accept_suggestion()
    elseif require("luasnip").jumpable(1) then
      return require("luasnip").jump(1)
    else
      return "<Tab>"
    end
  end, { expr = true, remap = true })
end

return M
