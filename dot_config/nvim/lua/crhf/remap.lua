vim.g.mapleader = " "

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<C-h>", "<cmd>noh<CR>")

vim.keymap.set(
	"n",
	"<leader>ip",
	"<cmd>keepjumps execute 'norm gg/\\<import\\>/'<CR><cmd>keepjumps norm n<CR>O",
	{ desc = "python import" }
)

vim.keymap.set("n", "<leader>vwm", function()
	require("vim-with-me").StartVimWithMe()
end)
vim.keymap.set("n", "<leader>svwm", function()
	require("vim-with-me").StopVimWithMe()
end)

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])
vim.keymap.set({ "n", "v" }, "<leader>c", [["_c]])
-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
-- vim.keymap.set("n", "<leader>ff", vim.lsp.buf.format)

vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lprev<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lnext<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.dotfiles/nvim/.config/nvim/lua/crhf/packer.lua<CR>")
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>")

-- vim.keymap.set("n", "<leader><leader>", function()
--     vim.cmd("so")
-- end)

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<Up>", ":resize +5<cr>", opts)
vim.api.nvim_set_keymap("n", "<Down>", ":resize -5<cr>", opts)
vim.api.nvim_set_keymap("n", "<Left>", ":vert resize -5<cr>", opts)
vim.api.nvim_set_keymap("n", "<Right>", ":vert resize +5<cr>", opts)

vim.keymap.set("n", "<leader>wr", function()
	vim.o.wrap = not vim.o.wrap
end, { desc = "toggle text wrap" })

-- vim.cmd([[nnoremap <expr> j (v:count > 1 ? "m'" . v:count . 'j' : 'gj')]])
-- vim.cmd([[nnoremap <expr> j (v:count > 1 ? "m'" . v:count . 'j' : 'gj')]])
vim.cmd([[nnoremap j gj]])
vim.cmd([[nnoremap gj j]])
vim.cmd([[nnoremap k gk]])
vim.cmd([[nnoremap gk k]])
-- vim.cmd([[nnoremap 0 g0]])
-- vim.cmd([[nnoremap g0 0]])
-- vim.cmd([[nnoremap $ g$]])
-- vim.cmd([[nnoremap g$ $]])
