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
                    enabled = true,
                    auto_refresh = true,
                },
                suggestion = {
                    enabled = true,
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
            })

            -- hide copilot suggestions when cmp menu is open
            -- to prevent odd behavior/garbled up suggestions
            local cmp_status_ok, cmp = pcall(require, "cmp")
            if cmp_status_ok then
                cmp.event:on("menu_opened", function()
                    vim.b.copilot_suggestion_hidden = true
                end)

                cmp.event:on("menu_closed", function()
                    vim.b.copilot_suggestion_hidden = false
                end)
            end

            -- Clean virtual text when leaving insert mode through <Ctrl-c>
            -- Maybe I should just stop using this key combination ;-). It's a bit annoying
            vim.keymap.set("i", "<C-c>", function()
                require("copilot/suggestion").dismiss()
                vim.cmd("stopinsert")
            end, { noremap = false, silent = true })

            -- Copilot is attached as Lsp. To investigate communication with the server,
            -- set log level to DEBUG and have a look at the lsp log, e.g. with:
            -- tail -f $HOME/.local/state/nvim/lsp.log | grep -i copilot
            --vim.lsp.set_log_level("DEBUG")

            -- Enable on specific files / folders
            -- Inspiration taken from here: https://github.com/zbirenbaum/copilot.lua/issues/74
            -- I am not 100% sure whether this approach is 100% safe because the Lsp is attached
            -- and detached again short after to my understanding. But it seems to work.
            local augroup = vim.api.nvim_create_augroup("copilot-disable-patterns", { clear = true })
            vim.api.nvim_create_autocmd("LspAttach", {
                group = augroup,
                pattern = "*",
                callback = function(args)
                    -- Enables copilot only for files in allowed working directories
                    --
                    -- If the buffer has a name (file associated), the path is matched
                    -- If not, we check if CWD is an allowed directory
                    --
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if client.name ~= "copilot" then
                        return
                    end

                    local bufname = vim.api.nvim_buf_get_name(0)
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
                    }
                    for _, pattern in ipairs(enable_patterns) do
                        if (bufname == "" and cwd:match("^" .. pattern)) or bufname:match("^" .. pattern) then
                            enable_ai = true
                            break
                        end
                    end

                    -- Disable copilot on buffers bigger than 100kb
                    -- (https://til.codeinthehole.com/posts/how-to-automatically-disable-github-copilot-in-vim-when-editing-large-files/)
                    if bufname ~= "" then
                        local fsize = vim.fn.getfsize(bufname)
                        if fsize > 100000 or fsize == -2 then
                            enable_ai = false
                        end
                    end

                    vim.defer_fn(function()
                        -- print("Copilot " .. (enable_ai and "attach" or "detach"))
                        vim.cmd("silent Copilot " .. (enable_ai and "attach" or "detach"))
                    end, 0)
                end,
            })
        end,
    },
    {
        "zbirenbaum/copilot-cmp",
        dependencies = {
            "hrsh7th/nvim-cmp",
        },
        config = function()
            require("copilot_cmp").setup()
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
    -- Disabled for now - I currently have no access to the chat feature
    -- {
    --     -- See also https://github.com/jellydn/lazy-nvim-ide/blob/main/lua/plugins/extras/copilot-chat.lua
    --     -- for ideas to make more use of it
    --     "jellydn/CopilotChat.nvim",
    --     opts = {
    --         mode = "split",
    --         debug = true,
    --         -- show_help = "yes",
    --         prompts = {
    --             Explain = "Explain how it works.",
    --             Review = "Review the following code and provide concise suggestions.",
    --             Tests = "Briefly explain how the selected code works, then generate unit tests.",
    --             Refactor = "Refactor the code to improve clarity and readability.",
    --         },
    --     },
    --     branch = "canary",
    --     build = function()
    --         vim.defer_fn(function()
    --             vim.cmd("UpdateRemotePlugins")
    --             vim.notify("CopilotChat - Updated remote plugins. Please restart Neovim.")
    --         end, 3000)
    --     end,
    --     event = "VeryLazy",
    --     keys = {
    --         { "<leader>cce", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
    --         { "<leader>cct", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
    --         { "<leader>ccr", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
    --         { "<leader>ccR", "<cmd>CopilotChatRefactor<cr>", desc = "CopilotChat - Refactor code" },
    --     },
    -- },
}
