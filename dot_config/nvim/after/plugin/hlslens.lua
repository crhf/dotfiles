require('hlslens').setup({
        override_lens = function(render, posList, nearest, idx, relIdx)
            local sfw = vim.v.searchforward == 1
            local indicator, text, chunks
            local absRelIdx = math.abs(relIdx)

            if absRelIdx ~= 0 then
                return
            end

            if absRelIdx > 1 then
                indicator = ('%d%s'):format(absRelIdx, sfw ~= (relIdx > 1) and 'N' or 'n')
            elseif absRelIdx == 1 then
                indicator = sfw ~= (relIdx == 1) and 'N' or 'n'
            else
                indicator = ''
            end

            local lnum, col = unpack(posList[idx])
            local cnt = #posList
            if nearest then
                if indicator ~= '' then
                    text = ('[%s %d/%d]'):format(indicator, idx, cnt)
                else
                    text = ('[%d/%d]'):format(idx, cnt)
                end
                chunks = { { ' ', 'Ignore' }, { text, 'HlSearchLensNear' } }
            else
                text = ('[%s %d/%d]'):format(indicator, idx, cnt)
                chunks = { { ' ', 'Ignore' }, { text, 'HlSearchLens' } }
            end
            render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
        end

})
-- require("scrollbar.handlers.search").setup(
--     {
--         build_position_cb = function(plist, _, _, _)
--             require("scrollbar.handlers.search").handler.show(plist.start_pos)
--         end,
--         override_lens = function(render, posList, nearest, idx, relIdx)
--             local sfw = vim.v.searchforward == 1
--             local indicator, text, chunks
--             local absRelIdx = math.abs(relIdx)
--             if absRelIdx > 1 then
--                 indicator = ('%d%s'):format(absRelIdx, sfw ~= (relIdx > 1) and 'N' or 'n')
--             elseif absRelIdx == 1 then
--                 indicator = sfw ~= (relIdx == 1) and 'N' or 'n'
--             else
--                 indicator = ''
--             end
--
--             local lnum, col = unpack(posList[idx])
--             local cnt = #posList
--             if nearest then
--                 if indicator ~= '' then
--                     text = ('[%s %d/%d]'):format(indicator, idx, cnt)
--                 else
--                     text = ('[%d/%d]'):format(idx, cnt)
--                 end
--                 chunks = { { ' ', 'Ignore' }, { text, 'HlSearchLensNear' } }
--             else
--                 text = ('[%s %d/%d]'):format(indicator, idx, cnt)
--                 -- text = ''
--                 chunks = { { ' ', 'Ignore' }, { text, 'HlSearchLens' } }
--             end
--             render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
--         end
--     }
-- )

-- vim.cmd([[
--     augroup scrollbar_search_hide
--     autocmd!
--     autocmd CmdlineLeave : lua require('scrollbar.handlers.search').handler.hide()
--     augroup END
-- ]])
