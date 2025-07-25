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

for i = 1, 9 do
  vim.keymap.set("n", "<leader>" .. i, i .. "gt", { noremap = true, silent = true })
end

-- param remove_original: boolean
--   true  => remove original line entirely
--   false => replace original line with an empty line
local function move_line_after_import(remove_original)
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor_line = vim.api.nvim_win_get_cursor(0)[1] - 1

  -- Get current line and strip leading whitespace
  local line = vim.api.nvim_buf_get_lines(bufnr, cursor_line, cursor_line + 1, false)[1]
  if not line then
    return
  end
  local trimmed_line = line:gsub("^%s+", "")

  if remove_original then
    -- Remove original line completely
    vim.api.nvim_buf_set_lines(bufnr, cursor_line, cursor_line + 1, false, {})
  else
    -- Replace original line with empty line
    vim.api.nvim_buf_set_lines(bufnr, cursor_line, cursor_line + 1, false, { "" })
  end

  -- Find the last import line
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local insert_line = 0
  for i, l in ipairs(lines) do
    if l:match("^import ") or l:match("^from .+ import ") then
      insert_line = i
    end
  end

  -- Insert the trimmed line after the last import
  vim.api.nvim_buf_set_lines(bufnr, insert_line, insert_line, false, { trimmed_line })
end

vim.keymap.set(
  "n",
  "<leader>oo",
  -- move_line_after_last_import,
  function()
    move_line_after_import(true)
  end,
  { desc = "Move current line after last import, trimming whitespace" }
)
vim.keymap.set(
  "i",
  "<c-l>",
  -- move_line_after_last_import,
  function()
    move_line_after_import(false)
  end,
  { desc = "Move current line after last import, trimming whitespace" }
)

-- Scroll up 6 lines with Ctrl-y
vim.keymap.set("n", "<C-y>", "6<C-y>", { noremap = true, silent = true })

-- Scroll down 6 lines with Ctrl-e
vim.keymap.set("n", "<C-e>", "6<C-e>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>K", "<cmd>source %<cr>", { noremap = true, silent = true })
