return {
  {
    "folke/persistence.nvim",
    enabled = true,
  },

  {
    "pocco81/auto-save.nvim",
    enabled = true,
    commit = "979b6c82f60cfa80f4cf437d77446d0ded0addf0",
    opts = {
      enabled = true, -- start auto-save when the plugin is loaded (i.e. when your package manager loads it)
      execution_message = {
        message = function() -- message to print on save
          return ""
        end,
        dim = 0.18, -- dim the color of `message`
        cleaning_interval = 1250, -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
      },
      -- trigger_events = { "InsertLeave", "TextChanged" }, -- vim events that trigger auto-save. See :h events
      trigger_events = { "InsertLeave", "TextChanged" }, -- vim events that trigger auto-save. See :h events
      -- function that determines whether to save the current buffer or not
      -- return true: if buffer is ok to be saved
      -- return false: if it's not ok to be saved
      condition = function(buf)
        -- check if buf exists
        local fn = vim.fn
        local api = vim.api
        if not (api.nvim_buf_is_valid(buf) and fn.buflisted(buf)) then
          return false
        end

        local filetype = vim.bo[buf].filetype
        if
          filetype == "harpoon"
          or filetype == "oil"
          or filetype == "snacks_picker_input"
          or filetype == "snacks_picker_preview"
          or filetype == "snacks_picker_list"
        then
          return false
        end

        local fn = vim.fn
        local utils = require("auto-save.utils.data")

        if fn.getbufvar(buf, "&modifiable") == 1 and utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
          return true -- met condition(s), can save
        end
        return false -- can't save
      end,
      write_all_buffers = true, -- write all buffers when the current one meets `condition`
      debounce_delay = 135, -- saves the file at most every `debounce_delay` milliseconds
      callbacks = {
        -- functions to be executed at different intervals
        enabling = nil, -- ran when enabling auto-save
        disabling = nil, -- ran when disabling auto-save
        before_asserting_save = nil, -- ran before checking `condition`
        before_saving = nil, -- ran before doing the actual save
        after_saving = nil, -- ran after doing the actual save
      },
    },
  },

  {
    "VPavliashvili/json-nvim",
    ft = "json", -- only load for json filetype
  },

  -- {
  --   "phelipetls/jsonpath.nvim",
  --   ft = "json",
  --   keys = {
  --     {
  --       "<leader>jj",
  --       function()
  --         local file = vim.fn.expand("%:p")
  --         local json_path = require("jsonpath").get()
  --
  --         local cmd = string.format("jq -r '%s' %s", json_path, file)
  --         local result = vim.fn.system(cmd)
  --
  --         local buf = vim.api.nvim_create_buf(false, true)
  --
  --         vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.fn.split(result, "\n"))
  --
  --         -- get buf number of buf
  --
  --         -- vim.api.nvim_set_option_value("wrap", true)
  --
  --         -- auto detect filetype of buffer
  --         vim.api.nvim_set_option_value("filetype", "markdown", { buf = buf })
  --
  --         local width = vim.api.nvim_win_get_width(0)
  --         local height = vim.api.nvim_win_get_height(0)
  --
  --         vim.api.nvim_open_win(buf, true, {
  --           relative = "win",
  --           width = width - math.floor(width * 0.2),
  --           height = height - math.floor(height * 0.2),
  --           row = 5,
  --           col = 5,
  --           style = "minimal",
  --           border = "single",
  --         })
  --       end,
  --       desc = "copy json path",
  --       buffer = true,
  --     },
  --   },
  -- },

  {
    "m00qek/baleia.nvim",
    version = "*",
    config = function()
      vim.g.baleia = require("baleia").setup({})

      -- Command to colorize the current buffer
      vim.api.nvim_create_user_command("BaleiaColorize", function()
        vim.g.baleia.once(vim.api.nvim_get_current_buf())
      end, { bang = true })

      -- Command to show logs
      vim.api.nvim_create_user_command("BaleiaLogs", vim.g.baleia.logger.show, { bang = true })
    end,
  },

  {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    ft = { "org" },
    config = function()
      -- Setup orgmode
      require("orgmode").setup({
        org_agenda_files = "~/orgfiles/**/*",
        org_default_notes_file = "~/orgfiles/refile.org",
        org_capture_templates = {
          t = {
            description = "Todo",
            template = "* TODO %?\n  %U\n  %a",
            target = "~/orgfiles/todo.org",
          },
          j = {
            description = "Journal",
            template = "\n*** %<%Y-%m-%d> %<%A>\n**** %U\n\n%?",
            target = "~/orgfiles/journal.org",
          },
        },
        mappings = {
          global = {
            org_toggle_checkbox = "<leader>oC",
          },
        },
      })

      -- NOTE: If you are using nvim-treesitter with ~ensure_installed = "all"~ option
      -- add ~org~ to ignore_install
      -- require('nvim-treesitter.configs').setup({
      --   ensure_installed = 'all',
      --   ignore_install = { 'org' },
      -- })
    end,
  },

  {
    "cameron-wags/rainbow_csv.nvim",
    config = true,
    ft = {
      "csv",
      "tsv",
      "csv_semicolon",
      "csv_whitespace",
      "csv_pipe",
      "rfc_csv",
      "rfc_semicolon",
    },
    cmd = {
      "RainbowDelim",
      "RainbowDelimSimple",
      "RainbowDelimQuoted",
      "RainbowMultiDelim",
    },
  },

  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    build = "cd app && yarn install",
    config = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
  },
}
