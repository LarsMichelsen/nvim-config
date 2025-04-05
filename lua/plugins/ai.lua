return {
    {
        -- Provides code suggestions based on the current context
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        build = ":Copilot auth",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                panel = {
                    enabled = false, -- Use blink
                    auto_refresh = true,
                },
                suggestion = {
                    enabled = false, -- Use blink
                    auto_trigger = true,
                    -- done by nvim-cmp
                    accept = false, -- disable built-in keymapping
                },
                filetypes = {
                    yaml = false,
                    markdown = true,
                    help = false,
                    gitcommit = true,
                    gitrebase = true,
                    hgcommit = false,
                    svn = false,
                    cvs = false,
                    ["."] = false,
                },
                copilot_model = "gpt-4o-copilot",
                should_attach = function(_, bufname)
                    local cwd = vim.fn.getcwd() .. "/"

                    local enable_ai = false

                    -- see on matching doc
                    -- https://www.lua.org/manual/5.3/manual.html#pdf-string.match
                    -- https://www.lua.org/manual/5.3/manual.html#6.4.1
                    local home_dir = vim.fn.expand("~")
                    local enable_patterns = {
                        home_dir .. "/.config/nvim/",
                        home_dir .. "/git/checkmk/",
                        home_dir .. "/git/checkmk%-%d%.%d%.%d/",
                        home_dir .. "/git/cma/",
                        home_dir .. "/git/cma-%d%.%d/",
                        home_dir .. "/git/lm/nagvis/",
                        home_dir .. "/git/cmk-app/",
                        home_dir .. "/git/gerrit/",
                    }
                    for _, pattern in ipairs(enable_patterns) do
                        if (bufname == "" and cwd:match("^" .. pattern)) or bufname:match("^" .. pattern) then
                            enable_ai = true
                            break
                        end
                    end

                    -- Disable copilot on buffers bigger than 300kb
                    -- (https://til.codeinthehole.com/posts/how-to-automatically-disable-github-copilot-in-vim-when-editing-large-files/)
                    if bufname ~= "" then
                        local fsize = vim.fn.getfsize(bufname)
                        if fsize > 300000 or fsize == -2 then
                            enable_ai = false
                        end
                    end

                    return enable_ai
                end,
            })

            -- -- hide copilot suggestions when cmp menu is open
            -- -- to prevent odd behavior/garbled up suggestions
            -- local cmp_status_ok, cmp = pcall(require, "cmp")
            -- if cmp_status_ok then
            --     cmp.event:on("menu_opened", function()
            --         vim.b.copilot_suggestion_hidden = true
            --     end)

            --     cmp.event:on("menu_closed", function()
            --         vim.b.copilot_suggestion_hidden = false
            --     end)
            -- end

            -- -- Clean virtual text when leaving insert mode through <Ctrl-c>
            -- -- Maybe I should just stop using this key combination ;-). It's a bit annoying
            -- vim.keymap.set("i", "<C-c>", function()
            --     require("copilot/suggestion").dismiss()
            --     vim.cmd("stopinsert")
            -- end, { noremap = false, silent = true })

            -- Copilot is attached as Lsp. To investigate communication with the server,
            -- set log level to DEBUG and have a look at the lsp log, e.g. with:
            -- tail -f $HOME/.local/state/nvim/lsp.log | grep -i copilot
            --vim.lsp.set_log_level("DEBUG")
        end,
    },
    {
        "zbirenbaum/copilot-cmp",
        dependencies = {
            "copilot.lua",
            "lspkind.nvim",
        },
        config = true,
        init = function()
            vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
        end,
    },
    {
        "AndreM222/copilot-lualine",
        dependencies = {
            "nvim-lualine/lualine.nvim",
        },
        config = function()
            require("copilot_cmp").setup()
        end,
    },
    {
        -- See also https://github.com/jellydn/lazy-nvim-ide/blob/main/lua/plugins/extras/copilot-chat-v2.lua
        -- for ideas to make more use of it
        "CopilotC-Nvim/CopilotChat.nvim",
        dependencies = {
            { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
            { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
        },
        opts = {
            mode = "split",
            debug = true,
            -- show_help = "yes",
            prompts = {
                -- Code related prompts
                Explain = "Please explain how the following code works.",
                Review = "Please review the following code and provide suggestions for improvement.",
                Tests = "Please explain how the selected code works, then generate unit tests for it.",
                Refactor = "Please refactor the following code to improve its clarity and readability.",
                FixCode = "Please fix the following code to make it work as intended.",
                FixError = "Please explain the error in the following text and provide a solution.",
                BetterNamings = "Please provide better names for the following variables and functions.",
                Documentation = "Please provide documentation for the following code.",
                -- Text related prompts
                Summarize = "Please summarize the following text.",
                Spelling = "Please correct any grammar and spelling errors in the following text.",
                Wording = "Please improve the grammar and wording of the following text.",
                Concise = "Please rewrite the following text to make it more concise.",
            },
        },
        branch = "main",
        build = function()
            vim.defer_fn(function()
                vim.cmd("UpdateRemotePlugins")
                vim.notify("CopilotChat - Updated remote plugins. Please restart Neovim.")
            end, 3000)
        end,
        event = "VeryLazy",
        keys = {
            { "<leader>ae", "<cmd>CopilotChatExplain<cr>", desc = "Chat - Explain code" },
            { "<leader>at", "<cmd>CopilotChatTests<cr>", desc = "Chat - Generate tests" },
            { "<leader>ar", "<cmd>CopilotChatReview<cr>", desc = "Chat - Review code" },
            { "<leader>aR", "<cmd>CopilotChatRefactor<cr>", desc = "Chat - Refactor code" },
            { "<leader>an", "<cmd>CopilotChatBetterNamings<cr>", desc = "Chat - Better naming" },
            { "<leader>af", "<cmd>CopilotChatFixCode<cr>", desc = "Chat - Fix code" },
            { "<leader>as", "<cmd>CopilotChatSummarize<cr>", desc = "Chat - Summarize text" },
            { "<leader>aS", "<cmd>CopilotChatSummarize<cr>", desc = "Chat - Spelling text" },
            { "<leader>aw", "<cmd>CopilotChatWording<cr>", desc = "Chat - Improve text" },
            { "<leader>ac", "<cmd>CopilotChatConcise<cr>", desc = "Chat - Concise text" },
        },
    },
}
