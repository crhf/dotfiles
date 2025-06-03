return {
  {
    "stevearc/conform.nvim",
    opts = {
      fomat_on_save = false,
      format_after_save = false,
      formatters_by_ft = {
        python = { "isort", "black" },
        html = { "prettier" },
        php = { "pretty-php" },
        twig = { "djlint", "twig-cs-fixer" },
        javascript = { "prettier" },
        json = { "jq" },
        tex = { "tex-fmt" }
      },
      formatters = {
        ["php-cs-fixer"] = {
          command = "php-cs-fixer",
          args = {
            "fix",
            "--rules=@PSR12", -- Formatting preset. Other presets are available, see the php-cs-fixer docs.
            "$FILENAME",
          },
          stdin = false,
        },
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
