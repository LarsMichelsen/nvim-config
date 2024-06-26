--
-- Fuzzy find using fzf (Triggered using CTRL-A)
--

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
                    preview = {
                        horizontal = "right:40%",
                    },
                },
                grep = {
                    rg_opts = '--smart-case -g "!{.git,node_modules,.mypy_cache,swagger-ui-3,tests/qa-test-data,third_party}/*" -g !redoc.standalone.js -g "!*.lock" --type-not svg --type-not po',
                },
                files = {
                    rg_opts = '--smart-case -g "!{.git,node_modules,.mypy_cache,swagger-ui-3,tests/qa-test-data}/*" -g "!third_party/*" -g !redoc.standalone.js -g "!*.lock" --type-not svg --type-not po',
                },
                oldfiles = {
                    include_current_session = true,
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
            local wk = require("which-key")
            wk.register({
                ["<C-t>"] = { "<cmd>lua require('fzf-lua').files()<CR>", "Find files" },
                ["<C-p>"] = { "<cmd>lua require('fzf-lua').git_files()<CR>", "Find git files" },
                ["<C-l>"] = { "<cmd>lua require('fzf-lua').git_bcommits()<CR>", "Find git commits" },
                ["<C-b>"] = { "<cmd>lua require('fzf-lua').buffers()<CR>", "Find buffers" },
                ["<C-h>"] = { "<cmd>lua require('fzf-lua').oldfiles()<CR>", "Find file history" },
                --["<C-a>"] = { "<cmd>lua require('fzf-lua').grep_project()<CR>", "Find in files" },
                ["<C-a>"] = { "<cmd>lua require('fzf-lua').live_grep_native()<CR>", "Find in files" },
                ["<leader>wf"] = { "<cmd>lua require('fzf-lua').grep_cword()<CR>", "Find word under cursor" },
            })
        end,
    },
}
