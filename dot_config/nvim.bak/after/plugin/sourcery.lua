require 'lspconfig'.sourcery.setup {
    init_options = {
        --- The Sourcery token for authenticating the user.
        --- This is retrieved from the Sourcery website and must be
        --- provided by each user. The extension must provide a
        --- configuration option for the user to provide this value.
        token = 'user_XnVUuvOfQClW72c2Szj_a7GRgbY_gcB3j0TR4JubYqcuy5vGtG7rjGIzUwM',

        --- The extension's name and version as defined by the extension.
        extension_version = 'vim.lsp',

        --- The editor's name and version as defined by the editor.
        editor_version = 'vim',
    },
}
