local dap = require 'dap'

netcoredbg_install = require('mason-registry')
    .get_package('netcoredbg')
    :get_install_path()

-- dap.adapters.coreclr = {
--     type = 'executable',
--     command = netcoredbg_install .. '/netcoredbg',
--     args = { '--interpreter=vscode' }
-- }
--
--
-- dap.configurations.cs = {
--     {
--         type = "coreclr",
--         name = "launch - netcoredbg",
--         request = "launch",
--         program = function()
--             return vim.fn.input('Path to dll:\n', vim.fn.fnamemodify(vim.fn.expand('%'), ":p:h:h") .. '/bin/x86/Debug/', 'file')
--         end,
--     },
-- }
