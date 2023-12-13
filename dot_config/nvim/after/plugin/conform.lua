require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		-- Conform will run multiple formatters sequentially
		python = { "isort", "black" },
		-- Use a sub-list to run only the first available formatter
		javascript = { { "prettierd", "prettier" } },
		json = { "biome" },
		csharp = { "clang-format" },
		java = { "google-java-format" },
	},
})

vim.keymap.set({ "n", "v" }, "<leader>ff", function()
	require("conform").format({
		lsp_fallback = true,
	})
end)
