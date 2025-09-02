return {
  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = {
        auto_trigger = false,
      },
    },
    keys = {
      { "<leader>ae", "<cmd>Copilot enable | Copilot status<cr>", { desc = "Copilot enable" } },
      { "<leader>ad", "<cmd>Copilot disable | Copilot status<cr>", { desc = "Copilot disable" } },
      { "<leader>ac", "<cmd>Copilot toggle | Copilot status<cr>", { desc = "Copilot enable" } },
    },
  },
}
