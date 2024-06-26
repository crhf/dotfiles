-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.api.nvim_set_keymap("n", "<C-right>", ":resize +5<cr>", {})
vim.api.nvim_set_keymap("n", "<C-left>", ":resize -5<cr>", {})
vim.api.nvim_set_keymap("n", "<C-down>", ":vert resize -5<cr>", {})
vim.api.nvim_set_keymap("n", "<C-up>", ":vert resize +5<cr>", {})
