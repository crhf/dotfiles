local actions = require("telescope.actions")
local mappings = {
	i = {
		["<C-l>"] = "close",
		["<Esc>"] = false,
		["<C-c>"] = false,
		-- ["<C-j>"] = "move_selection_next",
		-- ["<C-k>"] = "move_selection_previous",
		-- ["<C-p>"] = false,
		-- ["<C-n>"] = false,
		["<C-k>"] = actions.send_to_qflist + actions.open_qflist,
		["<C-j>"] = actions.send_selected_to_qflist + actions.open_qflist,
		["<C-h>"] = "which_key",
	},
	n = {
		["<C-l>"] = "close",
		["<Esc>"] = false,
		["<C-c>"] = false,
		-- ["<C-j>"] = "move_selection_next",
		-- ["<C-k>"] = "move_selection_previous",
		-- ["<C-p>"] = false,
		-- ["<C-n>"] = false,
		["<C-k>"] = actions.send_to_qflist + actions.open_qflist,
		["<C-h>"] = "which_key",
	},
}
local fzf_opts = {
	fuzzy = true, -- false will only do exact matching
	override_generic_sorter = true, -- override the generic sorter
	override_file_sorter = true, -- override the file sorter
	case_mode = "smart_case", -- or "ignore_case" or "respect_case"
}
local telescope = require("telescope")
telescope.setup({
	defaults = {
		mappings = mappings,
	},
	pickers = {
		lsp_dynamic_workspace_symbols = {
			sorter = telescope.extensions.fzf.native_fzf_sorter(fzf_opts),
		},
	},
	extensions = {
		fzf = fzf_opts,
		file_browser = {
			theme = "ivy",
			hijack_netrw = true,
			mappings = mappings,
		},
	},
	-- pickers = {
	--     find_files = {
	--         mappings = mappings,
	--     },
	--     grep_string = {
	--         mappings = mappings,
	--     },
	--     live_grep = {
	--         mappings = mappings,
	--     },
	--     current_buffer_fuzzy_find = {
	--         mappings = mappings,
	--     },
	--     lsp_references = {
	--         mappings = mappings,
	--     },
	--     lsp_document_symbols = {
	--         mappings = mappings,
	--     },
	--     lsp_dynamic_workspace_symbols = {
	--         mappings = mappings,
	--     },
	--     help_tags = {
	--         mappings = mappings,
	--     },
	--     oldfiles = {
	--         mappings = mappings,
	--     },
	--     diagnostics = {
	--         mappings = mappings,
	--     },
	-- },
})
telescope.load_extension("fzf")
telescope.load_extension("file_browser")

local builtin = require("telescope.builtin")
-- vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set("n", "<leader>pf", function()
	builtin.find_files({ no_ignore = true })
end)
vim.keymap.set("n", "<leader>gf", builtin.git_files, {})
vim.keymap.set("n", "<leader>ps", function()
	-- builtin.grep_string({ search = vim.fn.input("Grep > ") });
	builtin.live_grep()
end)
vim.keymap.set("n", "<leader>/", function()
	require("telescope.builtin").current_buffer_fuzzy_find()
	-- vim.keymap.set('n', '<leader>/', function()
	--     require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
	--         winblend = 10,
	--         previewer = false,
	--     })
end, { desc = "[/] Fuzzily search in current buffer" })
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })

vim.keymap.set("n", "<leader>sd", function()
	require("telescope.builtin").diagnostics({ bufnr = 0 })
end, { desc = "[S]earch [D]iagnostics" })

vim.keymap.set("n", "<leader>sa", function()
	require("telescope.builtin").diagnostics({ bufnr=nil, sort_by="severity" })
end, { desc = "[S]earch [A]ll diagnostics" })

vim.keymap.set("n", "<leader>sc", require("telescope.builtin").commands, { desc = "[S]earch [C]ommands" })
vim.keymap.set("n", "<leader>sp", require("telescope.builtin").oldfiles, { desc = "[S]earch [P]revious Files" })
vim.keymap.set("n", "<leader>sm", require("telescope.builtin").marks, { desc = "[S]earch [M]arks" })
vim.keymap.set("n", "<leader>sr", require("telescope.builtin").resume, { desc = "[S]earch [R]esume" })
