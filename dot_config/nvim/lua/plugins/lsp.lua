local function pylsp_config()
  return {
    settings = {
      pylsp = {
        plugins = {
          pycodestyle = {
            enabled = false,
          },
          rope_autoimport = {
            enabled = false,
          },
          rope_completion = {
            enabled = false,
          },
          jedi_symbols = {
            enabled = false,
          },
          jedi_completion = {
            enabled = true,
            include_params = false,
            fuzzy = true,
            include_class_objects = true,
            include_function_objects = true,
          },
          pyflakes = {
            enabled = false,
          },
        },
      },
    },
    on_attach = function(client, bufnr)
      client.server_capabilities.documentSymbolProvider = false
      client.server_capabilities.workspaceSymbolProvider = false
      client.server_capabilities.referencesProvider = false
      client.server_capabilities.definitionProvider = false
    end,
  }
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.inlay_hints.enabled = false

      table.insert(opts.servers["*"].keys, {
        "gr",
        function()
          Snacks.picker.lsp_references({ include_current = true })
        end,
        nowait = true,
        desc = "References",
      })

      opts.servers.pylsp = pylsp_config()
    end,
  },

  {
    "python-rope/ropevim",
  },
}
