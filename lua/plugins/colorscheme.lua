return {
    "Tsuzat/NeoSolarized.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
        require("NeoSolarized").setup({
            transparent = false, -- otherwise dark/light toggle won't work
            styles = {
                -- Style to be applied to different syntax groups
                comments = { italic = false },
                keywords = { italic = true },
                functions = { bold = true },
                variables = {},
                string = { italic = false },
                underline = false, -- true/false; for global underline
                undercurl = false, -- true/false; for global undercurl
            },
            -- Add specific hightlight groups
            on_highlights = function(highlights, colors)
                highlights.NormalFloat.bg = colors.bg1
            end,
        })
        vim.cmd([[ colorscheme NeoSolarized ]])

        vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#004000" })
        vim.api.nvim_set_hl(0, "DiffChange", { bg = "#084245" })
        vim.api.nvim_set_hl(0, "DiffText", { bg = "#43636e" })
        vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#002b36", fg = "#2d393d" })
    end,
}
