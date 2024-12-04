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

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa",
    },
  },
}
