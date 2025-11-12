local function jedi_config()
  return {
    settings = {},
    on_attach = function(client, bufnr)
      client.server_capabilities.documentSymbolProvider = false
      client.server_capabilities.workspaceSymbolProvider = false
      client.server_capabilities.referencesProvider = false
    end,
  }
end

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

local function pyright_config()
  return {
    settings = {
      pyright = {
        disableLanguageServices = false,
        openFilesOnly = false,
        analysis = {
          diagnosticMode = "workspace",
        },
      },
    },
    on_attach = function(client, bufnr)
      -- pyright doesn't respect client capabilities, so need to change server
      -- capabilities after client initialization
      -- client.server_capabilities.completionProvider = false
      client.server_capabilities = require("vim.lsp.protocol").resolve_capabilities({
        completionProvider = false,
        referencesProvider = true,
        definitionProvider = true,
        documentSymbolProvider = true,
        workspaceSymbolProvider = true,
        documentHighlightProvider = {
          workDoneProgress = false,
        },
        textDocumentSync = {
          change = 2,
          openClose = true,
          save = true,
          willSave = false,
          willSaveWaitUntil = false,
        },
        signatureHelpProvider = {
          triggerCharacters = {},
          retriggerCharacters = {},
        },
      })
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

      -- opts.servers.pylsp = pylsp_config()

      opts.servers.jedi_language_server = jedi_config()

      opts.servers.pyright = pyright_config()
    end,
  },

  {
    "python-rope/ropevim",
  },
}
