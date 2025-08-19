return {
  {
    "nvim-treesitter/playground",
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      textobjects = {
        select = {
          enable = true,
          keymaps = {
            ["ak"] = "@block.outer",
            ["ik"] = "@block.inner",
          },
        },
        selection_modes = {
          ["@block.outer"] = "V",
          ["@block.inner"] = "V",
        },
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    -- opts = {
    --   textobjects = {
    --     move = {
    --       goto_next_start = {
    --         ["]b"] = "@block.inner",
    --       },
    --       goto_next_end = {
    --         ["]B"] = "@block.inner",
    --       },
    --       goto_previous_start = {
    --         ["[b"] = "@block.inner",
    --       },
    --       goto_previous_end = {
    --         ["[B"] = "@block.inner",
    --       },
    --     },
    --   },
    -- },
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
      {
        "f",
        require("nvim-treesitter.textobjects.repeatable_move").builtin_f_expr,
        mode = { "n", "x", "o" },
        expr = true,
      },
      {
        "F",
        require("nvim-treesitter.textobjects.repeatable_move").builtin_F_expr,
        mode = { "n", "x", "o" },
        expr = true,
      },
      {
        "t",
        require("nvim-treesitter.textobjects.repeatable_move").builtin_t_expr,
        mode = { "n", "x", "o" },
        expr = true,
      },
      {
        "T",
        require("nvim-treesitter.textobjects.repeatable_move").builtin_T_expr,
        mode = { "n", "x", "o" },
        expr = true,
      },
    },
  },

  {
    "yioneko/nvim-yati",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter" },
    },
  },
}
