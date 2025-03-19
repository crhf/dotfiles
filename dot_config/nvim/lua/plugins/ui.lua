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
    opts = function(_, opts)
      local LazyVim = require("lazyvim.util")
      local icons = LazyVim.config.icons

      local winbar = {
        lualine_a = {
          -- { "diff", symbols = { added = icons.git.Added, modified = icons.git.Modified, removed = icons.git.Removed } },
        },
        lualine_b = {
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
        },
        lualine_c = {
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
        lualine_b = {
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
        },
        lualine_c = {
          -- LazyVim.lualine.root_dir(),
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
        table.insert(winbar.lualine_c, #winbar.lualine_c + 1, {
          symbols and symbols.get,
          cond = symbols and symbols.has,
        })
      end

      -- opts["winbar"] = winbar
      -- opts["inactive_winbar"] = inactive_winbar

      -- table.insert(
      --   opts["sections"]["lualine_c"],
      --   #opts["sections"]["lualine_c"],
      --   { "buffers", show_filename_only = true, mode = 2 }
      -- )
      return {
        winbar = winbar,
        inactive_winbar = inactive_winbar,
        sections = {
          lualine_b = {},
          lualine_c = {
            {
              "buffers",
              max_length = vim.o.columns * 2 / 3,
              symbols = {
                modified = "",
                alternate_file = "",
              },
              component_separators = { left = "", right = "" },
              buffers_color = {
                -- Same values as the general color option can be used here.
                active = "lualine_b_normal", -- Color for inactive buffer.
                inactive = "lualine_c_normal", -- Color for active buffer.
              },
            },
          },

          lualine_x = { { "searchcount" } },
          lualine_y = { { "filetype" }, { "location" } },
          lualine_z = { { "branch", icon = icons.git.Branch, padding = { left = 1, right = 0 } } },
        },
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
  },
}
