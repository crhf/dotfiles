return {
  {
    "hrsh7th/nvim-cmp",
    opts = {
      mapping = {
        ["<CR>"] = require("cmp").config.disable,
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = false,
      },
      servers = {
        pyright = {
          settings = {
            pyright = {
              disableLanguageServices = false,
              openFilesOnly = false,
              analysis = {
                diagnosticMode = "workspace",
              },
            },
            -- python = {
            --     analysis = {
            --         autoSearchPaths = true,
            --         diagnosticMode = "workspace",
            --         useLibraryCodeForTypes = true,
            --         autoImportCompletions = true,
            --     },
            -- },
            -- linting = { pylintEnabled = false }
          },
          on_attach = function(client, bufnr)
            --     for key, value in pairs(client.server_capabilities) do
            --         if value == true then
            --             client.server_capabilities[key] = false
            --         end
            --     end
            client.server_capabilities = require("vim.lsp.protocol").resolve_capabilities({
              referencesProvider = true,
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
              -- completionProvider = false,
              -- completion = {
              --   completionItem = {
              --     completionItemKind = {},
              --     completionList = {
              --       -- itemDefaults = { "editRange", "insertTextFormat", "insertTextMode", "data" },
              --       itemDefaults = {  },
              --     },
              --   },
              -- },
            })
            require("nvim-navic").attach(client, bufnr)
            -- end
          end,
        },
        jedi_language_server = {
          settings = {
            jediSettings = {
              debug = true
            }
          },
          on_attach = function(client, bufnr)
            client.server_capabilities.documentSymbolProvider = false
            client.server_capabilities.workspaceSymbolProvider = false
            client.server_capabilities.referencesProvider = false

            -- client.server_capabilities.completionProvider = true
            -- require("nvim-navic").attach(client, bufnr)
          end,
        },
      },
    },
  },
}
