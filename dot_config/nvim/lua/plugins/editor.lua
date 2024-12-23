return {
  {
    "echasnovski/mini.files",
    lazy = false,
    config = function(_, opts)
      local minifiles = require("mini.files")

      -- TODO: add keymap for harpooning an fs entry

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          vim.keymap.set("n", "gr", minifiles.refresh, { buffer = args.data.buf_id, desc = "Refresh" })
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          vim.keymap.set("n", "gyy", function()
            local path = minifiles.get_fs_entry().path
            vim.fn.setreg("+", vim.fn.fnamemodify(path, ":t"))
          end, { buffer = args.data.buf_id, desc = "Copy file name" })
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          vim.keymap.set("n", "gyY", function()
            local path = minifiles.get_fs_entry().path
            vim.fn.setreg("+", vim.fn.fnamemodify(path, ":~:."))
          end, { buffer = args.data.buf_id, desc = "Copy relative path" })
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          vim.keymap.set("n", "gYY", function()
            vim.fn.setreg("+", minifiles.get_fs_entry().path)
          end, { buffer = args.data.buf_id, desc = "Copy absolute path" })
        end,
      })

      -- LazyVim default config starts
      require("mini.files").setup(opts)

      local show_dotfiles = true
      local filter_show = function(fs_entry)
        return true
      end
      local filter_hide = function(fs_entry)
        return not vim.startswith(fs_entry.name, ".")
      end

      local toggle_dotfiles = function()
        show_dotfiles = not show_dotfiles
        local new_filter = show_dotfiles and filter_show or filter_hide
        require("mini.files").refresh({ content = { filter = new_filter } })
      end

      local map_split = function(buf_id, lhs, direction, close_on_file)
        local rhs = function()
          local new_target_window
          local cur_target_window = require("mini.files").get_target_window()
          if cur_target_window ~= nil then
            vim.api.nvim_win_call(cur_target_window, function()
              vim.cmd("belowright " .. direction .. " split")
              new_target_window = vim.api.nvim_get_current_win()
            end)

            require("mini.files").set_target_window(new_target_window)
            require("mini.files").go_in({ close_on_file = close_on_file })
          end
        end

        local desc = "Open in " .. direction .. " split"
        if close_on_file then
          desc = desc .. " and close"
        end
        vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
      end

      local files_set_cwd = function()
        local cur_entry_path = MiniFiles.get_fs_entry().path
        local cur_directory = vim.fs.dirname(cur_entry_path)
        if cur_directory ~= nil then
          vim.fn.chdir(cur_directory)
        end
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          local buf_id = args.data.buf_id

          vim.keymap.set(
            "n",
            opts.mappings and opts.mappings.toggle_hidden or "g.",
            toggle_dotfiles,
            { buffer = buf_id, desc = "Toggle hidden files" }
          )

          vim.keymap.set(
            "n",
            opts.mappings and opts.mappings.change_cwd or "gc",
            files_set_cwd,
            { buffer = args.data.buf_id, desc = "Set cwd" }
          )

          map_split(buf_id, opts.mappings and opts.mappings.go_in_horizontal or "<C-w>s", "horizontal", false)
          map_split(buf_id, opts.mappings and opts.mappings.go_in_vertical or "<C-w>v", "vertical", false)
          map_split(buf_id, opts.mappings and opts.mappings.go_in_horizontal_plus or "<C-w>S", "horizontal", true)
          map_split(buf_id, opts.mappings and opts.mappings.go_in_vertical_plus or "<C-w>V", "vertical", true)
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesActionRename",
        callback = function(event)
          LazyVim.lsp.on_rename(event.data.from, event.data.to)
        end,
      }) -- LazyVim default config ends
    end,
    opts = {
      options = {
        use_as_default_explorer = false,
      },
    },
  },
  -- {
  --   "stevearc/oil.nvim",
  --   keys = {
  --     { "-", "<cmd>Oil<cr>", { desc = "Open parent directory" } },
  --   },
  --   opts = {
  --     default_file_explorer = false,
  --     keymaps = {
  --       ["gyy"] = {
  --         function()
  --           local name = require("oil").get_cursor_entry().name
  --           vim.fn.setreg("+", name)
  --         end,
  --       },
  --       ["gyY"] = {
  --         function()
  --           local oil = require("oil")
  --           local dir = oil.get_current_dir()
  --           local name = oil.get_cursor_entry().name
  --           local path = dir .. name
  --           vim.fn.setreg("+", vim.fn.fnamemodify(path, ":~:."))
  --         end,
  --       },
  --       ["gYY"] = {
  --         function()
  --           local oil = require("oil")
  --           local dir = oil.get_current_dir()
  --           local name = oil.get_cursor_entry().name
  --           local path = dir .. name
  --           vim.fn.setreg("+", path)
  --         end,
  --       },
  --     },
  --   },
  --   dependencies = { "nvim-tree/nvim-web-devicons" },
  -- },

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
            ["<leftrelease>"] = "open",
          },
        },
        follow_current_file = false,
        bind_to_cwd = false,
        hijack_netrw_behavior = "open_default",
      },
    },
  },

  -- {
  --   "nvim-tree/nvim-tree.lua",
  --   enabled = true,
  --   config = function()
  --     require("nvim-tree").setup({
  --       on_attach = function(bufnr)
  --         local api = require("nvim-tree.api")
  --
  --         local function opts(desc)
  --           return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  --         end
  --
  --         api.config.mappings.default_on_attach(bufnr)
  --
  --         -- local function single_click_edit(node)
  --         --   vim.defer_fn(function()
  --         --     local win = vim.api.nvim_get_current_win()
  --         --     local view = require("nvim-tree.view")
  --         --     if view.get_winnr() ~= win then
  --         --       return
  --         --     end
  --         --     local actions = require("nvim-tree.actions.dispatch")
  --         --     actions.dispatch("edit")
  --         --   end, 10)
  --         -- end
  --         --
  --         vim.keymap.set("n", "<LeftRelease>", api.node.open.edit, opts("LeftClick"))
  --       end,
  --
  --       diagnostics = {
  --         enable = true,
  --         show_on_dirs = false,
  --         show_on_open_dirs = true,
  --         debounce_delay = 50,
  --         severity = {
  --           min = vim.diagnostic.severity.HINT,
  --           max = vim.diagnostic.severity.ERROR,
  --         },
  --         icons = {
  --           hint = "",
  --           info = "",
  --           warning = "",
  --           error = "",
  --         },
  --       },
  --       view = {
  --         relativenumber = true,
  --       },
  --       actions = {
  --         open_file = {
  --           resize_window = false,
  --         },
  --       },
  --       renderer = {
  --         icons = {
  --           web_devicons = {
  --             folder = {
  --               enable = false,
  --               color = true,
  --             },
  --           },
  --         },
  --       },
  --       filters = {
  --         git_ignored = false,
  --       },
  --       notify = {
  --         threshold = vim.log.levels.WARN,
  --         absolute_path = true,
  --       },
  --     })
  --     local api = require("nvim-tree.api")
  --     -- local node_api = require('nvim-tree-api.node')
  --     vim.keymap.set("n", "<leader>tt", function()
  --       api.tree.toggle({ focus = false })
  --     end)
  --     vim.keymap.set("n", "<leader>tf", function()
  --       api.tree.find_file()
  --     end)
  --     -- vim.keymap.set("n", "<leader>pv", function() api.tree.focus() end)
  --     -- vim.cmd([[autocmd filetype NvimTree nnoremap j j]])
  --     -- vim.cmd([[autocmd filetype NvimTree nnoremap k k]])
  --   end,
  --   version = "v1.4.0",
  -- },

  -- @type LazySpec
  -- {
  --   "mikavilpas/yazi.nvim",
  --   event = "VeryLazy",
  --   keys = {
  --     -- 👇 in this section, choose your own keymappings!
  --     {
  --       "-",
  --       "<cmd>Yazi<cr>",
  --       desc = "Open yazi at the current file",
  --     },
  --     {
  --       -- Open in the current working directory
  --       "<leader>E",
  --       "<cmd>Yazi cwd<cr>",
  --       desc = "Open the file manager in nvim's working directory",
  --     },
  --     -- {
  --     --   -- NOTE: this requires a version of yazi that includes
  --     --   -- https://github.com/sxyazi/yazi/pull/1305 from 2024-07-18
  --     --   "<c-up>",
  --     --   "<cmd>Yazi toggle<cr>",
  --     --   desc = "Resume the last yazi session",
  --     -- },
  --   },
  --   ---@type YaziConfig
  --   opts = {
  --     -- if you want to open yazi instead of netrw, see below for more info
  --     open_for_directories = false,
  --     keymaps = {
  --       show_help = "g?",
  --     },
  --   },
  -- },

  {
    "lambdalisue/vim-fern",
    keys = {
      { "-", mode = { "n", "x", "o" }, "<Cmd>Fern . -reveal=%<CR>" },
      { "<leader>e", mode = { "n", "x", "o" }, "<Cmd>Fern . -drawer -toggle<CR>" },
      {
        "<leader>fe",
        mode = { "n", "x", "o" },
        function()
          cmd = "FernDo FernReveal " .. vim.fn.expand("%:p")
          vim.cmd(cmd)
        end,
      },
    },
  },
  { "lambdalisue/vim-fern-hijack", dependencies = { "lambdalisue/vim-fern" } },
  { "lambdalisue/vim-fern-git-status", dependencies = { "lambdalisue/vim-fern" } },
  {
    "lambdalisue/vim-fern-renderer-nerdfont",
    dependencies = { "lambdalisue/vim-fern", "lambdalisue/vim-nerdfont" },
    config = function()
      vim.cmd([[let g:fern#renderer = "nerdfont"]])
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        mappings = {
          i = {
            ["<C-j>"] = require("telescope.actions").send_to_qflist + require("telescope.actions").open_qflist,
            ["<C-k>"] = require("telescope.actions").send_selected_to_qflist + require("telescope.actions").open_qflist,
            ["<C-q>"] = false,
            ["<M-q>"] = false,
          },
        },
      },
    },
  },

  {
    "folke/flash.nvim",
    enabled = false,
    event = "VeryLazy",
    vscode = true,
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  {
    "ggandor/flit.nvim",
    enabled = false,
  },

  {
    "sindrets/diffview.nvim",
    commit = "4516612",
  },
}
