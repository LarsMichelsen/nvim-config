-- Display tabs at the beginning of a line as bad.
-- Make trailing whitespace be flagged as bad.
vim.cmd("highlight BadWhitespace ctermbg=red guibg=red")
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*",
    command = "syntax match BadWhitespace /^\t\\+/",
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*",
    command = "syntax match BadWhitespace /\\s\\+$/",
})

-- Highlight characters that goes beyond the 100 column limit
-- http://youtu.be/aHm36-na4-4
vim.cmd([[
highlight ColorColumn ctermbg=1
call matchadd('ColorColumn', '\%101v', 100)
]])

-- When opening a file, always jump to the last known cursor position.
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    pattern = { "*" },
    callback = function()
        local ft = vim.opt_local.filetype:get()
        -- don't apply to git messages
        if ft:match("commit") or ft:match("rebase") then
            return
        end
        -- get position of last saved edit
        local markpos = vim.api.nvim_buf_get_mark(0, '"')
        local line = markpos[1]
        local col = markpos[2]
        -- if in range, go there
        if (line > 1) and (line <= vim.api.nvim_buf_line_count(0)) then
            vim.api.nvim_win_set_cursor(0, { line, col })
        end
    end,
})

--
-- File type handling
--

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.make",
    command = "set filetype=make",
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.mk",
    command = "set syntax=python filetype=python",
})
