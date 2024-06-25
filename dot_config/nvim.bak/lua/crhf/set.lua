vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.loaded_matchparen = 1

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 4
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "100,120"
vim.opt.cursorline = true

vim.g.mapleader = " "

--diagnostics
vim.diagnostic.config({
  virtual_text = false, -- Turn off inline diagnostics
})

-- Use this if you want it to automatically show all diagnostics on the
-- current line in a floating window. Personally, I find this a bit
-- distracting and prefer to manually trigger it (see below). The
-- CursorHold event happens when after `updatetime` milliseconds. The
-- default is 4000 which is much too long
-- vim.cmd('autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()')
-- vim.o.updatetime = 300

-- Show all diagnostics on current line in floating window
-- )
-- vim.api.nvim_set_keymap(
  -- 'n', '<Leader>dd', ':lua vim.diagnostic.open_float()<CR>',
  -- { noremap = true, silent = true }
-- )
-- Go to next diagnostic (if there are multiple on the same line, only shows
-- one at a time in the floating window)
-- vim.api.nvim_set_keymap(
--   'n', '<Leader>dn', ':lua vim.diagnostic.goto_next()<CR>',
--   { noremap = true, silent = true }
-- )
-- Go to prev diagnostic (if there are multiple on the same line, only shows
-- one at a time in the floating window)
-- vim.api.nvim_set_keymap(
--   'n', '<Leader>dp', ':lua vim.diagnostic.goto_prev()<CR>',
--   { noremap = true, silent = true }
-- )

-- disable serveral things for large files
local aug = vim.api.nvim_create_augroup("buf_large", { clear = true })

vim.api.nvim_create_autocmd({ "BufReadPre" }, {
  callback = function()
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()))
    if ok and stats and (stats.size > 1000000) then
      vim.b.large_buf = true
      vim.cmd("syntax off")

      local have_illuminate, illuminate = pcall(require, 'illuminate')
      if have_illuminate then
        illuminate.pause_buf()
      end
      -- vim.cmd("IlluminatePauseBuf") -- disable vim-illuminate
      -- vim.cmd("IndentBlanklineDisable") -- disable indent-blankline.nvim
      vim.opt_local.foldmethod = "manual"
      vim.opt_local.spell = false
    else
      vim.b.large_buf = false
    end
  end,
  group = aug,
  pattern = "*",
})

vim.cmd[[set laststatus=3]]

vim.diagnostic.config({virtual_text = false})

vim.g.ale_hover_cursor = 0
