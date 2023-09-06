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
    }, view = { relativenumber = true }
}
local api = require('nvim-tree.api')
vim.keymap.set('n', '<leader>tt', function() api.tree.toggle({ focus = false }) end)
vim.keymap.set("n", "<leader>pv", function() api.tree.focus() end)
