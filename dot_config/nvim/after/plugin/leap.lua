require('leap').add_default_mappings()
-- require('leap').add_repeat_mappings(';', ',', {
--     -- False by default. If set to true, the keys will work like the
--     -- native semicolon/comma, i.e., forward/backward is understood in
--     -- relation to the last motion.
--     relative_directions = true,
--     -- By default, all modes are included.
--     modes = { 'n', 'x', 'o' },
-- })

-- Avoid duplicate cursors
vim.api.nvim_create_autocmd(
    "User",
    {
        callback = function()
            vim.cmd.hi("Cursor", "blend=100")
            vim.opt.guicursor:append { "a:Cursor/lCursor" }
        end,
        pattern = "LeapEnter"
    }
)
vim.api.nvim_create_autocmd(
    "User",
    {
        callback = function()
            vim.cmd.hi("Cursor", "blend=0")
            vim.opt.guicursor:remove { "a:Cursor/lCursor" }
        end,
        pattern = "LeapLeave"
    }
)

-- linewise operations
local function get_line_starts(winid, skip_range)
    local wininfo = vim.fn.getwininfo(winid)[1]
    local cur_line = vim.fn.line('.')
    -- Skip lines close to the cursor.
    local skip_range = skip_range or 2

    -- Get targets.
    local targets = {}
    local lnum = wininfo.topline
    while lnum <= wininfo.botline do
        local fold_end = vim.fn.foldclosedend(lnum)
        -- Skip folded ranges.
        if fold_end ~= -1 then
            lnum = fold_end + 1
        else
            if (lnum < cur_line - skip_range) or (lnum > cur_line + skip_range) then
                table.insert(targets, { pos = { lnum, 1 } })
            end
            lnum = lnum + 1
        end
    end

    -- Sort them by vertical screen distance from cursor.
    local cur_screen_row = vim.fn.screenpos(winid, cur_line, 1)['row']
    local function screen_rows_from_cur(t)
        local t_screen_row = vim.fn.screenpos(winid, t.pos[1], t.pos[2])['row']
        return math.abs(cur_screen_row - t_screen_row)
    end
    table.sort(targets, function(t1, t2)
        return screen_rows_from_cur(t1) < screen_rows_from_cur(t2)
    end)

    if #targets >= 1 then
        return targets
    end
end

-- You can pass an argument to specify a range to be skipped
-- before/after the cursor (default is +/-2).
function leap_linewise(skip_range)
    local winid = vim.api.nvim_get_current_win()
    require('leap').leap {
        target_windows = { winid },
        targets = get_line_starts(winid, skip_range),
    }
end

-- For maximum comfort, make sure to set the mappings in a way that
-- forces linewise selection:
vim.keymap.set('n', '\\', function() return "<cmd>lua leap_linewise()<cr>" end, {expr=true})
vim.keymap.set('x', '\\', function()
    -- Do not exit from V if already in it (pressing v/V/<C-v>
    -- again exits the corresponding Visual mode).
    return (vim.fn.mode(1) == "V" and "" or "V") .. "<cmd>lua leap_linewise()<cr>"
end, { expr = true })
vim.keymap.set('o', '\\', "V<cmd>lua leap_linewise()<cr>", { desc = 'leap linewise visual' })
