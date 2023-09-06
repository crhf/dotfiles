require "lspconfig".efm.setup {
    init_options = { documentFormatting = true },
    settings = {
        rootMarkers = { ".git/" },
        languages = {
            lua = {
                { formatCommand = 'lua-format -i', formatStdin = true }
            },
            python = {
                { formatCommand = "black -q -",                 formatStdin = true },
                { formatCommand = "isort -q --profile black -", formatStdin = true }
            },
            json = {
                { formatCommand = "underscore print", formatStdin = true }
            },
            sh = {
                { formatCommand = "shfmt", formatStdin = false }
            },
            yaml = {
                -- { formatCommand = "yamlfmt", formatStdin = false }
                { formatCommand = "npx prettier --parser yaml", formatStdin = true }
            },
        }
    }
}
