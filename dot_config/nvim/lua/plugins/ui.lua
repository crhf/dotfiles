return {
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },

  {
    "folke/noice.nvim",
    enabled = true,
  },
  {},

  {
    "rcarriga/nvim-notify",
    enabled = true,
  },

  {
    "j-hui/fidget.nvim",
    tag = "v1.4.5",
    -- enabled = false,
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = function()
      local LazyVim = require("lazyvim.util")
      local icons = LazyVim.config.icons

      local winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          LazyVim.lualine.root_dir(),
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          -- { LazyVim.lualine.pretty_path() },
          { "filename", path = 1 },
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      }

      local inactive_winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          LazyVim.lualine.root_dir(),
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          -- { LazyVim.lualine.pretty_path() },
          { "filename", path = 1 },
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      }

      if vim.g.trouble_lualine then
        local trouble = require("trouble")
        local symbols = trouble.statusline
          and trouble.statusline({
            mode = "symbols",
            groups = {},
            title = false,
            filter = { range = true },
            format = "{kind_icon}{symbol.name:Normal}",
            hl_group = "lualine_c_normal",
          })
        table.insert(winbar.lualine_c, {
          symbols and symbols.get,
          cond = symbols and symbols.has,
        })
      end

      return {
        winbar = winbar,
        inactive_winbar = inactive_winbar,
      }
    end,
  },

  -- {
  --   "karb94/neoscroll.nvim",
  --   tag = "0.2.0",
  --   config = function()
  --     require("neoscroll").setup({})
  --
  --     local neoscroll = require("neoscroll")
  --     local keymap = {
  --       ["<C-u>"] = function()
  --         neoscroll.ctrl_u({ duration = 30 })
  --       end,
  --       ["<C-d>"] = function()
  --         neoscroll.ctrl_d({ duration = 30 })
  --       end,
  --       ["<C-b>"] = function()
  --         neoscroll.ctrl_b({ duration = 450 })
  --       end,
  --       ["<C-f>"] = function()
  --         neoscroll.ctrl_f({ duration = 450 })
  --       end,
  --       ["<C-y>"] = function()
  --         neoscroll.scroll(-0.1, { move_cursor = false, duration = 10 })
  --       end,
  --       ["<C-e>"] = function()
  --         neoscroll.scroll(0.1, { move_cursor = false, duration = 10 })
  --       end,
  --       ["zt"] = function()
  --         neoscroll.zt({ half_win_duration = 4 })
  --       end,
  --       ["zz"] = function()
  --         neoscroll.zz({ half_win_duration = 4 })
  --       end,
  --       ["zb"] = function()
  --         neoscroll.zb({ half_win_duration = 4 })
  --       end,
  --     }
  --     local modes = { "n", "v", "x" }
  --     for key, func in pairs(keymap) do
  --       vim.keymap.set(modes, key, func)
  --     end
  --   end,
  -- },

  {
    "folke/snacks.nvim",
    opts = {
      terminal = {
        win = {
          position = "float",
        },
      },
    },
  }
}
