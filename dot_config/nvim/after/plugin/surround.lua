-- vim.cmd [[ let g:surround_no_mappings=1 ]]

require("nvim-surround").setup({
	move_cursor = false,
	keymaps = {
		insert = "<C-g>z",
		insert_line = "<C-g>Z",
		normal = "yz",
		normal_cur = "yzz",
		normal_line = "yZ",
		normal_cur_line = "yZZ",
		visual = "yz",
		visual_line = "yzz",
		delete = "dz",
		change = "cz",
		change_line = "czz",
	},
})
