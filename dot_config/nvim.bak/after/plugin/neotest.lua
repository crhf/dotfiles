require("neotest").setup({
    adapters = {
        require("neotest-python")({
            -- Extra arguments for nvim-dap configuration
            -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
            -- dap = { justMyCode = false },

            -- Command line arguments for runner
            -- Can also be a function to return dynamic values
            args = { "--log-level", "DEBUG" },

            -- Runner to use. Will use pytest if available by default.
            -- Can be a function to return dynamic value.
            runner = "pytest",

            -- Custom python path for the runner.
            -- Can be a string or a list of strings.
            -- Can also be a function to return dynamic value.
            -- If not provided, the path will be inferred by checking for
            -- virtual envs in the local directory and for Pipenev/Poetry configs
            -- python = ".venv/bin/python",

            -- Returns if a given file path is a test file.
            -- NB: This function is called a lot so don't perform any heavy tasks within it.
            -- is_test_file = function(file_path)
            -- ...
            -- end,
        })
    }
})

vim.keymap.set("n", "<leader>ut", require("neotest").run.run, { desc = 'run nearest [u]nit [t]est' })
vim.keymap.set("n", "<leader>uf", function() require("neotest").run.run(vim.fn.expand('%')) end,
    { desc = 'run current [u]nit test [f]ile' })
vim.keymap.set("n", "<leader>ug", function() require("neotest").run.run({ strategy = "dap" }) end,
    { desc = 'nearest [u]nit test debu[g]' })
vim.keymap.set("n", "<leader>us", function() require("neotest").run.stop() end, { desc = '[u]nit test [s]top' })
