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
}
