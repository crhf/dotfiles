-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<C-up>", "<cmd>resize +5<cr>", {})
vim.keymap.set("n", "<C-down>", "<cmd>resize -5<cr>", {})
vim.keymap.set("n", "<C-left>", "<cmd>vert resize -5<cr>", {})
vim.keymap.set("n", "<C-right>", "<cmd>vert resize +5<cr>", {})

vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>")

-- Unescaping json lines
local function unescape_current_line()
  local obj = vim.system(
    { "python3", "-c", "print(input().encode().decode('unicode_escape'), end='')" },
    { stdin = vim.api.nvim_get_current_line() }
  )
  local completed = obj:wait()
  return completed.stdout
end

vim.api.nvim_create_user_command("Unescape", function()
  vim.print(unescape_current_line())
end, {})

vim.api.nvim_create_user_command("UnescapeInFloatWin", function()
  local result = unescape_current_line()

  local buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.fn.split(result, "\n"))

  -- get buf number of buf

  -- vim.api.nvim_set_option_value("wrap", true)

  -- auto detect filetype of buffer
  vim.api.nvim_set_option_value("filetype", "markdown", { buf = buf })

  local width = vim.api.nvim_win_get_width(0)
  local height = vim.api.nvim_win_get_height(0)

  local row = math.floor(height * 0.1)
  local col = math.floor(width * 0.1)

  win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width - 2 * col,
    height = height - 2 * row,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  })

  vim.api.nvim_set_option_value("wrap", true, { win = win })
  vim.api.nvim_set_option_value("number", true, { win = win })
  vim.api.nvim_set_option_value("relativenumber", true, { win = win })
  vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>q<CR>", {})
  vim.api.nvim_buf_set_keymap(buf, "n", "<MiddleRelease>", "<cmd>q<CR>", {})
end, {})

vim.cmd([[aunmenu PopUp.How-to\ disable\ mouse ]])
vim.cmd([[aunmenu PopUp.Inspect ]])

vim.cmd([[amenu .600 PopUp.Unescape\ line <Cmd>UnescapeInFloatWin<CR>]])
vim.api.nvim_set_keymap("n", "<leader>jj", "<Cmd>UnescapeInFloatWin<CR>", {})

vim.cmd.amenu([[PopUp.Close\ floatwin <Cmd>fclose<CR>]])
