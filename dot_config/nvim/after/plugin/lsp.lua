local lsp = require('lsp-zero').preset({})

local get_hostname = function()
    local f = io.popen("/bin/hostname")
    local hostname = f:read("*a") or ""
    f:close()
    hostname = string.gsub(hostname, "\n$", "")
    return hostname
end
local hostname = get_hostname()

require('barbecue').setup({
    attach_navic = false, -- prevent barbecue from automatically attaching nvim-navic
    lead_custom_section = function() return " " .. hostname .. "  " end,
})

lsp.on_attach(function(client, bufnr)
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end
    -- local rc = client.resolved_capabilities
    -- if client.name == 'pylsp' then
    -- rc.rename = false
    -- rc.completion = false
    -- rc.format = false
    -- end

    -- if client.name == 'pyright' then
    -- rc.hover = false
    -- rc.definition = false
    -- rc.signature_help = false
    -- rc.format = false
    -- rc.completion = false
    -- rc.references = false
    -- end

    lsp.default_keymaps({ buffer = bufnr })
    -- vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
    vim.keymap.set({"n", "v"}, "<leader>ff", function()
        vim.lsp.buf.format { async = true }
    end)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
    vim.keymap.set("n", "<leader>rf", vim.lsp.buf.references)
    vim.keymap.set("n", "<leader>vh", vim.lsp.buf.hover)
    vim.keymap.set("n", "<leader>im", vim.lsp.buf.implementation)
    vim.keymap.set("n", "<leader>ac", vim.lsp.buf.code_action)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)

    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

    if client.server_capabilities.workspaceSymbolProvider then
        nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
    end

    --- Guard against servers without the signatureHelper capability
    if client.server_capabilities.signatureHelpProvider then
        require('lsp-overloads').setup(client, {
            -- UI options are mostly the same as those passed to vim.lsp.util.open_floating_preview
            ui = {
                border = "single", -- The border to use for the signature popup window. Accepts same border values as |nvim_open_win()|.
                height = nil, -- Height of the signature popup window (nil allows dynamic sizing based on content of the help)
                width = nil, -- Width of the signature popup window (nil allows dynamic sizing based on content of the help)
                wrap = true, -- Wrap long lines
                wrap_at = nil, -- Character to wrap at for computing height when wrap enabled
                max_width = 60, -- Maximum signature popup width
                max_height = 10, -- Maximum signature popup height
                -- Events that will close the signature popup window: use {"CursorMoved", "CursorMovedI", "InsertCharPre"} to hide the window when typing
                close_events = { "CursorMoved", "BufHidden", "InsertLeave" },
                focusable = true,                 -- Make the popup float focusable
                focus = false,                    -- If focusable is also true, and this is set to true, navigating through overloads will focus into the popup window (probably not what you want)
                offset_x = 0,                     -- Horizontal offset of the floating window relative to the cursor position
                offset_y = 0,                     -- Vertical offset of the floating window relative to the cursor position
                floating_window_above_cur_line = false, -- Attempt to float the popup above the cursor position
                -- (note, if the height of the float would be greater than the space left above the cursor, it will default
                -- to placing the float below the cursor. The max_height option allows for finer tuning of this)
            },
            keymaps = {
                next_signature = "<C-d>",
                previous_signature = "<C-u>",
                next_parameter = "<C-l>",
                previous_parameter = "<C-h>",
                close_signature = "<A-s>"
            },
            display_automatically = true -- Uses trigger characters to automatically display the signature overloads when typing a method signature
        })
    end

    -- if client.server_capabilities.documentSymbolProvider then
    -- require('nvim-navic').attach(client, bufnr)
    -- end
end)

-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

-- lsp.skip_server_setup({ 'pyright' })
require('lspconfig').pyright.setup({
    settings = {
        pyright = {
            disableLanguageServices = false
        },
        -- python = {
        --     analysis = {
        --         autoSearchPaths = true,
        --         diagnosticMode = "workspace",
        --         useLibraryCodeForTypes = false,
        --         autoImportCompletions = false,
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
        client.server_capabilities = require 'vim.lsp.protocol'.resolve_capabilities({
            documentSymbolProvider = true,
            workspaceSymbolProvider = true,
            documentHighlightProvider = {
                workDoneProgress = false
            },
            textDocumentSync = {
                change = 2,
                openClose = true,
                save = true,
                willSave = false,
                willSaveWaitUntil = false
            },
            signatureHelpProvider = {
                triggerCharacters = {},
                retriggerCharacters = {}
            }
        })
        require("nvim-navic").attach(client, bufnr)
        -- end
    end
})

require 'lspconfig'.omnisharp_mono.setup {
    on_attach = function (client, bufnr)
        require("nvim-navic").attach(client, bufnr)

        client.server_capabilities.documentFormattingProvider = nil
        client.server_capabilities.documentRangeFormattingProvider = nil
    end
}

local lspconfig = require 'lspconfig'
local util = require 'lspconfig.util'

local root_files = {
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    'pyrightconfig.json',
    '.git',
}

lspconfig.jedi_language_server.setup {
    root_dir = function(fname)
        return util.root_pattern(unpack(root_files))(fname)
    end,
    on_attach = function(client, bufnr)
        client.server_capabilities.documentSymbolProvider = false
        client.server_capabilities.workspaceSymbolProvider = false
        -- require("nvim-navic").attach(client, bufnr)
    end
    -- root_dir = function(fname, bufnr)
    -- local result = lspconfig.util.find_git_ancestor(fname) .. "src"
    -- print(result)
    -- return result
    -- return vim.fn.getcwd() .. "src"
    -- end
}

-- require('lspconfig').pylsp.setup({
--     settings = {
--         pylsp = {
--             plugins = {
--                 rope_autoimport = {
--                     enabled = true
--                 },
--                 autopep8 = {
--                     enabled = false
--                 },
--                 pycodestyle = {
--                     enabled = false
--                 },
--                 pyflakes = {
--                     enabled = false
--                 }
--             }
--
--         }
--     }
-- })

-- require('lspconfig').pyright.setup({
--     on_init = function(client)
--         client.server_capabilities.references = nil
--     end,
-- })
-- lsp.skip_server_setup({'pyright'})

lsp.skip_server_setup({ 'jdtls' })

lsp.setup() -- after specific lang servers, before cmp

local luasnip = require("luasnip")
local types = require("luasnip.util.types")

-- vim.api.nvim_set_hl(0, 'LuaSnipPlace', { bg = "#e3dee2", italic = true })

luasnip.setup({
    ext_opts = {
        [types.insertNode] = {
            unvisited = {
                -- virt_text = { { '|', 'Conceal' } },
                -- virt_text_pos = 'overlay',
                hl_group = 'Cursor'
            },
        },
        -- Add this to also have a placeholder in the final tabstop.
        -- See the discussion below for more context.
        [types.exitNode] = {
            unvisited = {
                virt_text = { { '|', 'Conceal' } },
                virt_text_pos = 'overlay',
                hl_group = 'Cursor'
            },
        },
    }
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.insert }),
    ['<C-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.insert }),
    ['<C-y>'] = cmp.mapping.close(),
    ['<C-e>'] = cmp.mapping.abort(),
    -- ['<C-e>'] = function()
    --     local active = cmp.get_active_entry()
    --     -- if active then
    --         -- return cmp.close()
    --     -- end
    --     local next = '<Cmd>lua require("cmp").mapping.select_next_item({ behavior = require("cmp").SelectBehavior.insert })()<CR>'
    --     local prev = '<Cmd>lua require("cmp").mapping.select_prev_item({ behavior = require("cmp").SelectBehavior.insert })()<CR>'
    --     local close = '<Cmd>lua require("cmp").close()<CR>'
    --     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-j>" .. "<C-k>" .. "<C-y>", true, true, true), 'i', true)
    -- end,
    ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            -- cmp.select_next_item()
            cmp.confirm({ select = true })
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
            -- they way you will only jump inside the snippet region
        elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
            -- elseif has_words_before() then
            -- cmp.complete()
        else
            fallback()
        end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
        else
            fallback()
        end
    end, { "i", "s" }),
    -- ["<C-Space>"] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
})

local buffer_source = {
    name = 'buffer',
    option = {
        get_bufnrs = function()
            local buf = vim.api.nvim_get_current_buf()
            local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
            if byte_size > 1024 * 1024 then -- 1 Megabyte max
                return {}
            end
            return { buf }
        end
    }
}
cmp.setup({
    mapping = cmp_mappings,
    window = {
        documentation = cmp.config.window.bordered()
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        -- { name = 'vsnip' }, -- For vsnip users.
        { name = 'luasnip' }, -- For luasnip users.
        -- { name = 'ultisnips' }, -- For ultisnips users.
        -- { name = 'snippy' }, -- For snippy users.
        { name = 'path',    option = { trailing_slash = true } },
    }, {
        { name = 'path', option = { trailing_slash = true } },
        buffer_source,
    }),
    -- , {
    --     { name = 'path',  option = { trailing_slash = true } },
    --     { name = 'buffer' },
    -- }),
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        end,
    },
    performance = {
      debounce = 30,
      throttle = 5,
      fetching_timeout = 70,
      confirm_resolve_timeout = 5,
      async_budget = 1,
      max_view_entries = 15,
    },
    -- performance = {
    --     debounce = 10,
    --     throttle = 0,
    --     fetching_timeout = 10
    -- }
    experimental = {
        ghost_text = true
    }
})


--[[
lsp.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})
]]
--

vim.keymap.set({ "i", "x", "v", "n" }, "<C-s>", function()
    if
        require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
        and not require('luasnip').session.jump_active
    then
        require('luasnip').unlink_current()
    end
end)

-- HACK: Cancel the snippet session when leaving insert mode.
-- local unlink_group = vim.api.nvim_create_augroup('UnlinkSnippet', {})
-- vim.api.nvim_create_autocmd('ModeChanged', {
--     group = unlink_group,
--     -- when going from select mode to normal and when leaving insert mode
--     pattern = { 's:n', 'i:*' },
--     callback = function(event)
--         if
--             luasnip.session
--             and luasnip.session.current_nodes[event.buf]
--             and not luasnip.session.jump_active
--         then
--             luasnip.unlink_current()
--         end
--     end,
-- })
