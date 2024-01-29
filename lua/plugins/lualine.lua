return {
    -- https://github.com/nvim-lualine/lualine.nvim
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "kyazdani42/nvim-web-devicons" },
        opts = function()
            return {
                options = {
                    icons_enabled = true,
                    theme = "solarized_dark",
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    disabled_filetypes = {
                        statusline = {},
                        winbar = {},
                    },
                    ignore_focus = {},
                    always_divide_middle = true,
                    globalstatus = false,
                    refresh = {
                        statusline = 1000,
                        tabline = 1000,
                        winbar = 1000,
                    },
                },
                sections = {
                    lualine_a = {
                        {
                            "mode",
                            fmt = function(str)
                                return str:sub(1, 1)
                            end,
                        },
                    },
                    lualine_b = {
                        "branch",
                        {
                            "diagnostics",
                            symbols = {
                                error = "✖ ",
                                warn = "⚠ ",
                                info = "I",
                                hint = "H",
                            },
                        },
                    },
                    lualine_c = {
                        {
                            "navic",
                            navic_opts = {
                                highlight = true,
                            },
                        },
                    },
                    lualine_x = {
                        -- see https://github.com/AndreM222/copilot-lualine
                        "copilot",
                        -- "encoding",
                    },
                    lualine_y = {
                        require("lsp-progress").progress,
                    },
                    lualine_z = {},
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { "filename" },
                    lualine_x = { "location" },
                    lualine_y = {},
                    lualine_z = {},
                },
                tabline = {},
                winbar = {},
                inactive_winbar = {},
                extensions = {},
            }
        end,
    },
    -- Added for path in lualine
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                ensure_installed = {
                    "dockerfile",
                    "lua",
                    "git_config",
                    "jsdoc",
                    "make",
                    "toml",
                    "yaml",
                    "markdown",
                    "markdown_inline",
                    "python",
                },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },
    -- Added for signature under cursor in lualine
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        opts = {
            hint_enable = false,
            wrap = true,
            -- floating_window_off_x = function()
            --     -- move to the right
            --     local wincol = vim.fn.wincol()
            --     local winwidth = vim.fn.winwidth(0)

            --     return winwidth
            -- end,
            -- floating_window_off_y = function()
            --     local linenr = vim.api.nvim_win_get_cursor(0)[1] -- buf line number
            --     -- move to the bottom
            --     local winline = vim.fn.winline() -- line number in the window
            --     local winheight = vim.fn.winheight(0)

            --     return winheight - winline + 1
            -- end,
        },
        config = function(_, opts)
            require("lsp_signature").setup(opts)
        end,
    },
}

---- listen to user event and trigger lualine refresh
--vim.cmd([[
--augroup lualine_augroup
--    autocmd!
--    autocmd User LspProgressStatusUpdated lua require("lualine").refresh()
--augroup END
--]])
