return {
  { "folke/flash.nvim", enabled = false },

  {
    "garymjr/nvim-snippets",
    opts = {
      friendly_snippets = false,
    },
    dependencies = { "rafamadriz/friendly-snippets" },
  },

  {
    "kevinhwang91/nvim-ufo",
    tag = "v1.4.0",
    opts = {
      provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
      end,
    },
    dependencies = {
      {
        "kevinhwang91/promise-async",
        tag = "v1.0.0",
      },
    },
  },

  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      for i, lang in ipairs(opts.auto_brackets) do
        if lang == "python" then
          table.remove(opts.auto_brackets, i)
        end
      end

      opts["performance"] = {
        debounce = 30,
        throttle = 5,
        fetching_timeout = 70,
        confirm_resolve_timeout = 5,
        async_budget = 1,
        max_view_entries = 15,
      }
    end,
  },
}
