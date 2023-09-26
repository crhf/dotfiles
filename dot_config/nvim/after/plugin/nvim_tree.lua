require("nvim-tree").setup {
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
    }, view = { relativenumber = true },
    actions = {
        open_file = {
            resize_window = false,
        }
    },
    renderer = {
        icons = {
            web_devicons = {
                folder = {
                    enable = false,
                    color = true
                },
            },
        }
    },
    filters = {
        git_ignored = false
    }
}
local api = require('nvim-tree.api')
vim.keymap.set('n', '<leader>tt', function() api.tree.toggle({ focus = false }) end)
vim.keymap.set('n', '<leader>tf', function() api.tree.find_file() end)
-- vim.keymap.set("n", "<leader>pv", function() api.tree.focus() end)
