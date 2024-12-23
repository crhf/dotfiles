-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local argv = vim.fn.argv()

    if vim.fn.argc() > 0 and vim.fn.isdirectory(argv[#argv]) ~= 0 then
      vim.cmd.cd(argv[#argv])
      vim.print("Changed directory to " .. argv[#argv])
    end

    return true
  end,
})
