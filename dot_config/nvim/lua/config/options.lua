-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.autoformat = false
vim.cmd([[ set clipboard=unnamedplus ]])

vim.cmd([[ set laststatus=3 ]])

vim.cmd([[ set showtabline=2 ]])

-- ## Tabline, defines how tabpages title looks like
-- For convenience of cross-probjects development, show project names directly.
--
function MyTabLine()
  local tabline = ""
  for index = 1, vim.fn.tabpagenr("$") do
    -- Select the highlighting for the current tabpage.
    if index == vim.fn.tabpagenr() then
      tabline = tabline .. "%#TabLineSel#"
    else
      tabline = tabline .. "%#TabLine#"
    end

    local win_num = vim.fn.tabpagewinnr(index)
    local working_directory = vim.fn.getcwd(win_num, index)
    local project_name = vim.fn.fnamemodify(working_directory, ":t")
    tabline = tabline .. " " .. project_name .. " "
  end

  return tabline
end
vim.go.tabline = "%!v:lua.MyTabLine()"

vim.g.ai_cmp = false
