-- claude code
-- https://docs.anthropic.com/en/docs/claude-code/overview
-- npm install -g @anthropic-ai/claude-code
local claude_code = {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  config = true,
  keys = {
    { "<leader>aa", nil,                              desc = "AI/Claude Code" },
    { "<leader>ac", "<cmd>ClaudeCode<cr>",            desc = "Toggle Claude" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",       desc = "Focus Claude" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>",   desc = "Resume Claude" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>",        mode = "v",              desc = "Send to Claude" },
    {
      "<leader>as",
      "<cmd>ClaudeCodeTreeAdd<cr>",
      desc = "Add file",
      ft = { "NvimTree", "neo-tree", "oil" },
    },
    -- Diff management
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Deny diff" },
  },
  opts = {
    focus_after_send = true,
  }
}

require('lazy').setup({
  -- 'RRethy/nvim-base16',
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build =
    'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
  },
  { 'nvim-telescope/telescope.nvim',   dependencies = { 'nvim-lua/plenary.nvim' } },
  'tpope/vim-fugitive',
  { 'nvim-treesitter/nvim-treesitter', cmd = 'TSUpdate' },
  'cescobaz/vim-snippets',
  --{ dir = '/home/buro/projects/vim-snippets' },
  { 'L3MON4D3/LuaSnip',          build = 'make install_jsregexp' },
  'saadparwaiz1/cmp_luasnip',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/nvim-cmp',
  {
    'neovim/nvim-lspconfig',
    --  version = "v0.1.8"
  },
  { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } },
  {
    'smoka7/hop.nvim',
    version = "*",
    opts = {},
  },
  -- { 'codota/tabnine-nvim', build = "./dl_binaries.sh" },
  claude_code
})
