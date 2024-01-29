--
-- Fuzzy find using fzf (Triggered using CTRL-A)
--

local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

return {
    {
        "ibhagwan/fzf-lua",
        -- optional for icon support
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local actions = require("fzf-lua.actions")
            require("fzf-lua").setup({
                winopts = {
                    height = 0.95,
                    width = 0.95,
                    row = 0.30,
                    col = 0.30,
                },
                files = {
                    rg_opts = '--smart-case -g "!{.git,node_modules,.mypy_cache,swagger-ui-3}/*" -g !redoc.standalone.js -g !Pipfile.lock',
                },
                actions = {
                    files = {
                        ["enter"] = actions.file_tabedit,
                        ["ctrl-s"] = actions.file_split,
                        ["ctrl-v"] = actions.file_vsplit,
                        ["ctrl-t"] = actions.file_tabedit,
                    },
                },
            })
        end,
        init = function()
            map("n", "<C-t>", "<cmd>lua require('fzf-lua').files()<CR>")
            map("n", "<C-p>", "<cmd>lua require('fzf-lua').git_files()<CR>")
            map("n", "<C-l>", "<cmd>lua require('fzf-lua').git_bcommits()<CR>")
            map("n", "<C-h>", "<cmd>lua require('fzf-lua').oldfiles()<CR>")
            map("n", "<C-a>", '<cmd>lua require("fzf-lua").live_grep_native()<CR>')
            --map('n', '<C-s>', ':Ag!<CR>')
            -- Immediately search for the word under the cursor in a new tab
            map("n", "<Leader>ag", "<cmd>lua require('fzf-lua').grep_cword()<CR>")
        end,
    },
}
