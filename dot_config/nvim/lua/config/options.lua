-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.autoformat = false

vim.cmd([[ set laststatus=3 ]])

vim.cmd([[ set showtabline=2 ]])

vim.cmd([[ set colorcolumn=89,121 ]])

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
    tabline = tabline .. " " .. index .. " " .. project_name .. " "
  end

  return tabline
end
vim.go.tabline = "%!v:lua.MyTabLine()"

vim.g.ai_cmp = false

if vim.env.WSL_DISTRO_NAME then
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
end

-- In case you don't want to use `:LazyExtras`,
-- then you need to set the option below.
vim.g.lazyvim_picker = "snacks"

-- https://github.com/wezterm/wezterm/issues/4607
vim.o.termsync = false

vim.g.vimtex_syntax_conceal_disable = 1

vim.g.lazyvim_python_lsp = "pyright"
