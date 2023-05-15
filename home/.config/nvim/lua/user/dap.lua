local M = {}

M.setup = function()
  local dap = require('dap')
  dap.adapters.mix_task = {
    type = 'executable',
    command = '/usr/local/opt/elixir-ls/libexec/debugger.sh',
    args = {}
  }
  dap.configurations.elixir = {
    {
      type = "mix_task",
      name = "mix test",
      task = 'test',
      taskArgs = { "--trace" },
      request = "launch",
      startApps = true, -- for Phoenix projects
      projectDir = "${workspaceFolder}",
      requireFiles = {
        "test/**/test_helper.exs",
        "test/**/*_test.exs"
      }
    },
  }

  vim.keymap.set('n', '<Leader>db', dap.toggle_breakpoint, {})
  vim.keymap.set('n', '<Leader>dp', dap.continue, {})
  vim.keymap.set('n', '<Leader>ds', dap.step_over, {})
  vim.keymap.set('n', '<Leader>di', dap.step_into, {})
  vim.keymap.set('n', '<Leader>do', dap.repl.open, {})
end

return M
