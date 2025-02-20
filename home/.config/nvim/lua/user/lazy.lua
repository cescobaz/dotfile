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
  { 'L3MON4D3/LuaSnip',          build = 'make install_jsregexp' },
  'saadparwaiz1/cmp_luasnip',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/nvim-cmp',
  { 'neovim/nvim-lspconfig',     version = "v0.1.8" },
  { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } },
  {
    'smoka7/hop.nvim',
    version = "*",
    opts = {},
  },
  -- {
  --   'Exafunction/codeium.vim',
  --   event = 'BufEnter'
  -- },
  -- { 'codota/tabnine-nvim', build = "./dl_binaries.sh" },
  {
    "yetone/avante.nvim",
    --dir = "/Users/buro/projects/external/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    opts = {
      -- add any opts here
      provider = "claude",                  -- Recommend using Claude
      auto_suggestions_provider = "claude", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "hrsh7th/nvim-cmp",            -- autocompletion for avante commands and mentions
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua",      -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
    },
  }
})
