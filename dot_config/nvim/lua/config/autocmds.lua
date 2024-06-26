-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
vim.api.nvim_create_augroup("MyInsertLeave", { clear = true })
vim.api.nvim_create_autocmd("InsertLeave", {
  group = "MyInsertLeave",
  pattern = "*",
  callback = function()
    require("lazyvim.util").format({ force = true })
  end,
})
