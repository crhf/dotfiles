return {
  -- add gruvbox
  { "sainnhe/gruvbox-material" },
  { "neanias/everforest-nvim" },
  { "mhartington/oceanic-next" },
  { "rebelot/kanagawa.nvim" },
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "shaunsingh/nord.nvim" },
  { "rose-pine/neovim", name = "rose-pine", opts = {
    variant = "moon",
  } },
  { "EdenEast/nightfox.nvim" },
  { "loctvl842/monokai-pro.nvim" },
  { "Shatur/neovim-ayu" },
  { "cocopon/iceberg.vim" },
  { "savq/melange-nvim" },
  { "mhartington/oceanic-next" },
  { "yorik1984/newpaper.nvim" },
  { "yorickpeterse/vim-paper" },
  {
    "zenbones-theme/zenbones.nvim",
    -- Optionally install Lush. Allows for more configuration or extending the colorscheme
    -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
    -- In Vim, compat mode is turned on as Lush only works in Neovim.
    dependencies = "rktjmp/lush.nvim",
    lazy = false,
    priority = 1000,
    -- you can set set configuration options here
    -- config = function()
    --     vim.g.zenbones_darken_comments = 45
    --     vim.cmd.colorscheme('zenbones')
    -- end
  },
  { "pgdouyon/vim-yin-yang" },
  -- Configure LazyVim to load gruvbox
  {
    "e-ink-colorscheme/e-ink.nvim",
    priority = 1000,
    -- config = function()
    --   require("e-ink").setup()
    --   vim.cmd.colorscheme("e-ink")
    --
    --   -- choose light mode or dark mode
    --   vim.opt.background = "dark"
    --   -- vim.opt.background = "light"
    --   --
    --   -- or do
    --   -- :set background=dark
    --   -- :set background=light
    -- end,
  },
  -- Using lazy.nvim
  {
    "metalelf0/black-metal-theme-neovim",
    lazy = false,
    priority = 1000,
    config = function()
      require("black-metal").setup({
        -- optional configuration here
      })
      require("black-metal").load()
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "yin",
    },
  },
}
