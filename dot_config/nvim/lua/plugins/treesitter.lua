return {
  {
    "nvim-treesitter/playground",
    commit = "ba48c6a",
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    keys = {
      {
        ";",
        require("nvim-treesitter.textobjects.repeatable_move").repeat_last_move,
        mode = { "n", "x", "o" },
      },
      {
        ",",
        require("nvim-treesitter.textobjects.repeatable_move").repeat_last_move_opposite,
        mode = { "n", "x", "o" },
      },
    },
  },

  {
    "yioneko/nvim-yati",
    commit = "df3dc06",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter" },
    },
  },
}
