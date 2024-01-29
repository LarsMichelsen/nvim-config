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
        })
        vim.cmd([[ colorscheme NeoSolarized ]])
    end,
}
