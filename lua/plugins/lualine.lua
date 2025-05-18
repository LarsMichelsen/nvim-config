return {
    -- https://github.com/nvim-lualine/lualine.nvim
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = function()
            return {
                options = {
                    icons_enabled = true,
                    theme = "solarized_dark",
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    disabled_filetypes = {
                        -- statusline = {},
                        -- winbar = {},
                        statusline = { "NvimTree", "Avante", "AvanteInput", "AvanteSelectedFiles" },
                        winbar = { "NvimTree", "Avante", "AvanteInput", "AvanteSelectedFiles" },
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
                            "filename",
                            path = 1,
                        },
                    },
                    -- Replaced with dropbar
                    -- lualine_c = {
                    --     {
                    --         "navic",
                    --         navic_opts = {
                    --             highlight = true,
                    --         },
                    --     },
                    -- },
                    lualine_x = {
                        -- see https://github.com/AndreM222/copilot-lualine
                    },
                    -- replaced with fidget
                    -- lualine_y = {
                    --     require("lsp-progress").progress,
                    -- },
                    lualine_y = {},
                    lualine_z = {
                        "copilot",
                    },
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { "path" },
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
}
