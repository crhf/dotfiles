return {
  {
    "stevearc/conform.nvim",
    opts = {
      fomat_on_save = false,
      format_after_save = false,
      formatters_by_ft = {
        python = { "isort", "black" },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      autoformat = false,
    },
  },
}
