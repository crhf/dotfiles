-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<C-up>", "<cmd>resize +5<cr>", {})
vim.keymap.set("n", "<C-down>", "<cmd>resize -5<cr>", {})
vim.keymap.set("n", "<C-left>", "<cmd>vert resize -5<cr>", {})
vim.keymap.set("n", "<C-right>", "<cmd>vert resize +5<cr>", {})

vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>")
