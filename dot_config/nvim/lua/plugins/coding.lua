return {

  { "folke/flash.nvim", enabled = false },

  -- {
  --   "garymjr/nvim-snippets",
  --   opts = {
  --     friendly_snippets = false,
  --   },
  --   dependencies = { "rafamadriz/friendly-snippets" },
  -- },

  -- {
  --   "kevinhwang91/nvim-ufo",
  --   tag = "v1.4.0",
  --   config = function()
  --     local ufo = require("ufo")
  --
  --     vim.o.foldcolumn = "1" -- '0' is not bad
  --     vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
  --     vim.o.foldlevelstart = 99
  --     vim.o.foldenable = true
  --
  --     -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
  --     vim.keymap.set("n", "zR", ufo.openAllFolds)
  --     vim.keymap.set("n", "zM", ufo.closeAllFolds)
  --
  --     ufo.setup({
  --       provider_selector = function(bufnr, filetype, buftype)
  --         return { "treesitter", "indent" }
  --       end,
  --     })
  --   end,
  --   dependencies = {
  --     {
  --       "kevinhwang91/promise-async",
  --       tag = "v1.0.0",
  --     },
  --   },
  -- },

  -- {
  --   "hrsh7th/nvim-cmp",
  --   opts = function(_, opts)
  --     -- opts.auto_brackets = opts.auto_brackets or {}
  --     -- table.insert(opts.auto_brackets, "python")
  --     -- opts.auto_brackets = { "python" }
  --     for i, lang in ipairs(opts.auto_brackets) do
  --       if lang == "python" then
  --         table.remove(opts.auto_brackets, i)
  --       end
  --     end
  --
  --     opts["performance"] = {
  --       debounce = 30,
  --       throttle = 5,
  --       fetching_timeout = 10,
  --       confirm_resolve_timeout = 5,
  --       async_budget = 1,
  --       max_view_entries = 15,
  --     }
  --
  --     opts["mapping"]["<CR>"] = require("cmp").config.disable
  --   end,
  -- },

  {
    "tpope/vim-abolish",
    tag = "v1.2",
  },

  {
    "andymass/vim-matchup",
    tag = "v0.7.3",
  },

  {
    "AndrewRadev/linediff.vim",
    tag = "v0.3.0",
  },

  {
    "tpope/vim-sleuth",
    tag = "v2.0",
  },

  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = {
        auto_trigger = false,
      },
    },
  },

  {
    "kawre/neotab.nvim",
    event = "InsertEnter",
    opts = {
      -- configuration goes here
    },
  },
}
