return {
  -- { "mason-org/mason.nvim", version = "1.11.0" },
  -- { "mason-org/mason-lspconfig.nvim", version = "1.32.0" },
  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = {
  --     inlay_hints = {
  --       enabled = false,
  --     },
  --   },
  -- },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      vim.lsp.set_log_level("debug")

      opts.inlay_hints.enabled = false

      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- change a keymap
      keys[#keys + 1] = {
        "gr",
        function()
          Snacks.picker.lsp_references({ include_current = true })
        end,
        nowait = true,
        desc = "References",
      }

      opts.servers.pylsp = {
        settings = {
          pylsp = {
            plugins = {
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
            },
          },
        },
        on_attach = function(client, bufnr)
          client.server_capabilities.documentSymbolProvider = false
          client.server_capabilities.workspaceSymbolProvider = false
          client.server_capabilities.referencesProvider = false
        end,
      }

      -- opts.servers.jedi_language_server = {
      --   settings = {
      --     -- jediSettings = {
      --     --   debug = true,
      --     -- },
      --   },
      --   on_attach = function(client, bufnr)
      --     client.server_capabilities.documentSymbolProvider = false
      --     client.server_capabilities.workspaceSymbolProvider = false
      --     client.server_capabilities.referencesProvider = false
      --   end,
      -- }

      opts.servers.pyright = {
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
          -- require("nvim-navic").attach(client, bufnr)
          -- end
        end,
      }
    end,
  },
}
-- return {
--   {
--     "neovim/nvim-lspconfig",
--     opts = function(_, opts)
--       local keys = require("lazyvim.plugins.lsp.keymaps").get()
--       keys[#keys + 1] = { "gr", false }
--
--       local function deepMerge(t1, t2)
--         local merged = {}
--
--         for key, value in pairs(t1) do
--           if type(value) == "table" and type(t2[key]) == "table" then
--             merged[key] = deepMerge(value, t2[key])
--           else
--             merged[key] = value
--           end
--         end
--
--         for key, value in pairs(t2) do
--           if merged[key] == nil then
--             merged[key] = value
--           end
--         end
--
--         return merged
--       end
--
--       local custom = {
--         diagnostics = {
--           virtual_text = false,
--         },
--         servers = {
--           pyright = {
--             settings = {
--               pyright = {
--                 disableLanguageServices = false,
--                 openFilesOnly = false,
--                 analysis = {
--                   diagnosticMode = "workspace",
--                 },
--               },
--               -- python = {
--               --     analysis = {
--               --         autoSearchPaths = true,
--               --         diagnosticMode = "workspace",
--               --         useLibraryCodeForTypes = true,
--               --         autoImportCompletions = true,
--               --     },
--               -- },
--               -- linting = { pylintEnabled = false }
--             },
--             on_attach = function(client, bufnr)
--               --     for key, value in pairs(client.server_capabilities) do
--               --         if value == true then
--               --             client.server_capabilities[key] = false
--               --         end
--               --     end
--               client.server_capabilities = require("vim.lsp.protocol").resolve_capabilities({
--                 referencesProvider = true,
--                 documentSymbolProvider = true,
--                 workspaceSymbolProvider = true,
--                 documentHighlightProvider = {
--                   workDoneProgress = false,
--                 },
--                 textDocumentSync = {
--                   change = 2,
--                   openClose = true,
--                   save = true,
--                   willSave = false,
--                   willSaveWaitUntil = false,
--                 },
--                 signatureHelpProvider = {
--                   triggerCharacters = {},
--                   retriggerCharacters = {},
--                 },
--                 -- completionProvider = false,
--                 -- completion = {
--                 --   completionItem = {
--                 --     completionItemKind = {},
--                 --     completionList = {
--                 --       -- itemDefaults = { "editRange", "insertTextFormat", "insertTextMode", "data" },
--                 --       itemDefaults = {  },
--                 --     },
--                 --   },
--                 -- },
--               })
--               require("nvim-navic").attach(client, bufnr)
--               -- end
--             end,
--           },
--           jedi_language_server = {
--             settings = {
--               jediSettings = {
--                 debug = true,
--               },
--             },
--             on_attach = function(client, bufnr)
--               client.server_capabilities.documentSymbolProvider = false
--               client.server_capabilities.workspaceSymbolProvider = false
--               client.server_capabilities.referencesProvider = false
--
--               -- client.server_capabilities.completionProvider = true
--               -- require("nvim-navic").attach(client, bufnr)
--             end,
--           },
--           phpactor = {
--             enabled = false,
--           },
--           intelephense = {
--             enabled = true,
--           },
--         },
--       }
--
--       return deepMerge(opts, custom)
--     end,
--   },
-- }
