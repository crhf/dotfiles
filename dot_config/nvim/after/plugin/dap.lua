vim.keymap.set("n", "<leader>1", require('dap').restart, { desc = "dap restart" })
vim.keymap.set("n", "<leader>2", require('dap').terminate, { desc = "dap terminate" })
vim.keymap.set("n", "<leader>3", require('dap').restart_frame, { desc = "dap restart frame" })
vim.keymap.set("n", "<leader>4", require('dap').run_last, { desc = "dap run last" })
vim.keymap.set("n", "<leader>5", require('dap').continue, { desc = "dap continue" })
vim.keymap.set("n", "<leader>7", require('dap').step_into, { desc = "dap step into" })
vim.keymap.set("n", "<leader>8", require('dap').step_over, { desc = "dap step over" })
vim.keymap.set("n", "<leader>9", require('dap').step_out, { desc = "dap step out" })
vim.keymap.set("n", "<leader>0", require('dap').run_to_cursor, { desc = "dap run to cursor" })

vim.keymap.set("n", "<leader>dk", require('dap').up, { desc = "dap up" })
vim.keymap.set("n", "<leader>dj", require('dap').down, { desc = "dap down" })

vim.keymap.set("n", "<leader>db", require('dap').toggle_breakpoint, { desc = "dap breakpoint" })
vim.keymap.set("n", "<leader>dB", ":lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
    { desc = "dap conditional breakpoint" })

vim.keymap.set('n', '<Leader>dp',
    function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end,
    { desc = "dap log point" })
vim.keymap.set('n', '<Leader>dr', require('dap').repl.open, { desc = "dap repl" })
vim.keymap.set('n', '<Leader>dl', require('dap').run_last, { desc = "dap run last" })


local dap = require('dap')

dap.adapters.vscode_mono_debug = {
    type = 'executable',
    command = '/usr/bin/mono',
    args = { '/home/crhf/installers/vscode-mono-debug/extension/bin/Release/mono-debug.exe' }
}

dap.configurations.cs = {
    {
        name = "launch-mono",
        type = "vscode_mono_debug",
        request = "launch",
        runtimeExecutable = "/usr/bin/mono",
        program = function()
            return vim.fn.input('Path to program', vim.fn.fnamemodify(vim.fn.expand('%'), ":p:h:h") .. '/bin/', 'file')
        end
    },
    {
        name = "attach-mono",
        type = "vscode_mono_debug",
        request = "attach",
        address = "localhost",
        port = 55555
    }
}
