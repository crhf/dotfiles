return {
  {
    "hrsh7th/nvim-cmp",
    opts = {
      mapping = {
        ["<CR>"] = require("cmp").config.disable,
      },
    },
  }
}
