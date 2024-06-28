return {
  {
    "echasnovski/mini.files",
    lazy = false,
    opts = {
      options = {
        use_as_default_explorer = true,
      },
    },
  },
  {
    "stevearc/oil.nvim",
    keys = {
      { "-", "<cmd>Oil<cr>", { desc = "Open parent directory" } },
    },
    opts = {
      default_file_explorer = false,
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
    keys = {
      {
        "<leader>sf",
        "<cmd>Neotree reveal<cr>",
      },
    },
    opts = {
      enabled = true,
      filesystem = {
        window = {
          mappings = {
            -- disable fuzzy finder
            ["/"] = "noop",
            ["z"] = "noop",
            ["<bs>"] = "close_node",
            ["-"] = "navigate_up",
            ["<tab>"] = "preview",
          },
        },
        follow_current_file = false,
        bind_to_cwd = false,
        hijack_netrw_behavior = "open_default",
      },
    },
  },

  {
    "nvim-tree/nvim-tree.lua",
    enabled = false,
    config = function()
      require("nvim-tree").setup({
        diagnostics = {
          enable = true,
          show_on_dirs = false,
          show_on_open_dirs = true,
          debounce_delay = 50,
          severity = {
            min = vim.diagnostic.severity.HINT,
            max = vim.diagnostic.severity.ERROR,
          },
          icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
          },
        },
        view = { relativenumber = true },
        actions = {
          open_file = {
            resize_window = false,
          },
        },
        renderer = {
          icons = {
            web_devicons = {
              folder = {
                enable = false,
                color = true,
              },
            },
          },
        },
        filters = {
          git_ignored = false,
        },
        notify = {
          threshold = vim.log.levels.WARN,
          absolute_path = true,
        },
      })
      local api = require("nvim-tree.api")
      -- local node_api = require('nvim-tree-api.node')
      vim.keymap.set("n", "<leader>tt", function()
        api.tree.toggle({ focus = false })
      end)
      vim.keymap.set("n", "<leader>tf", function()
        api.tree.find_file()
      end)
      -- vim.keymap.set("n", "<leader>pv", function() api.tree.focus() end)
      -- vim.cmd([[autocmd filetype NvimTree nnoremap j j]])
      -- vim.cmd([[autocmd filetype NvimTree nnoremap k k]])
    end,
    version = "v1.4.0",
  },

  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader>SS",
        function()
          require("telescope.builtin").lsp_workspace_symbols()
        end,
      },
    },
  },
}
