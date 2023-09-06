require("auto-session").setup {
    log_level = "error",
    auto_session_enabled = true,
    cwd_change_handling = {
        restore_upcoming_session = true,   -- already the default, no need to specify like this, only here as an example
        pre_cwd_changed_hook = nil,        -- already the default, no need to specify like this, only here as an example
        post_cwd_changed_hook = function() -- example refreshing the lualine status line _after_ the cwd changes
            require("lualine").refresh()   -- refresh lualine so the new session name is displayed in the status bar
        end,
    },
    pre_save_cmds = {
        function()
            local status_ok, api = pcall(require, "nvim-tree.api")
            if not status_ok then
                return
            end
            api.tree.close()
        end,
    },

    post_save_cmds = {
        function()
            local status_ok, api = pcall(require, "nvim-tree.api")
            if not status_ok then
                return
            end
            api.tree.toggle { focus = false, find_file = true }
        end,
    },

    post_restore_cmds = {
        function()
            local status_ok, api = pcall(require, "nvim-tree.api")
            if not status_ok then
                return
            end
            api.tree.toggle { focus = false, find_file = true }
        end,
    },
}
