return {
  {
    "zbirenbaum/copilot.lua",
    enable = false,
    opts = {
      suggestion = {
        auto_trigger = false,
      },
    },
    keys = {
      { "<leader>ae", "<cmd>Copilot enable | Copilot status<cr>", { desc = "Copilot enable" } },
      { "<leader>ad", "<cmd>Copilot disable | Copilot status<cr>", { desc = "Copilot disable" } },
      { "<leader>ac", "<cmd>Copilot toggle | Copilot status<cr>", { desc = "Copilot enable" } },
    },
  },

  {
    "olimorris/codecompanion.nvim",
    opts = {},
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },

  {
    "Exafunction/windsurf.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "saghen/blink.cmp",
    },
    -- keys = {
    --   {
    --     "<M-;>",
    --     mode = { "i" },
    --     function()
    --       return vim.fn["codeium#Complete()"]()
    --     end,
    --     { expr = true, silent = true, desc = "trigger codeium" },
    --   },
    -- },
    config = function()
      require("codeium").setup({
        enable_cmp_source = false,
        virtual_text = {
          enabled = true,

          -- These are the defaults

          -- Set to true if you never want completions to be shown automatically.
          manual = true,
          -- A mapping of filetype to true or false, to enable virtual text.
          filetypes = {},
          -- Whether to enable virtual text of not for filetypes not specifically listed above.
          default_filetype_enabled = true,
          -- How long to wait (in ms) before requesting completions after typing stops.
          idle_delay = 75,
          -- Priority of the virtual text. This usually ensures that the completions appear on top of
          -- other plugins that also add virtual text, such as LSP inlay hints, but can be modified if
          -- desired.
          virtual_text_priority = 65535,
          -- Set to false to disable all key bindings for managing completions.
          map_keys = true,
          -- The key to press when hitting the accept keybinding but no completion is showing.
          -- Defaults to \t normally or <c-n> when a popup is showing.
          accept_fallback = nil,
          -- Key bindings for managing completions in virtual text mode.
          key_bindings = {
            -- Accept the current completion.
            accept = "<M-;>",
            -- Accept the next word.
            accept_word = false,
            -- Accept the next line.
            accept_line = "<C-j>",
            -- Clear the virtual text.
            clear = false,
            -- Cycle to the next completion.
            next = false,
            -- Cycle to the previous completion.
            prev = "<M-[>",
          },
        },
      })
    end,
    vim.keymap.set("i", "<M-]>", function()
      require("codeium.virtual_text").cycle_or_complete()
      print("Manually triggered codeium")
    end, { expr = true, silent = true }),
  },
}
