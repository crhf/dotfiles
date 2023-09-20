local dap, dapui = require("dap"), require("dapui")
require("dapui").setup()

vim.keymap.set('n', "<leader>ui", require('dapui').toggle)
-- vim.keymap.set("n", "<leader>4", function() require('dapui').float_element(nil, {enter=true}) end, {desc="dapui float"})
vim.keymap.set("n", "<leader>de", function() require('dapui').eval(nil, {context="repl", enter=true}) end, {desc="dapui eval"})

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
