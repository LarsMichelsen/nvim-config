return {
    "nathanaelkane/vim-indent-guides",
    event = { "BufReadPre", "BufNewFile" },
    init = function()
        vim.g.indent_guides_enable_on_vim_startup = 1
        vim.g.indent_guides_color_change_percent = 5
        vim.g.indent_guides_auto_colors = 0

        vim.api.nvim_create_autocmd({ "VimEnter", "Colorscheme" }, {
            pattern = "*",
            command = ":hi IndentGuidesOdd  guibg=#06303b ctermbg=3",
        })
        vim.api.nvim_create_autocmd({ "VimEnter", "Colorscheme" }, {
            pattern = "*",
            command = ":hi IndentGuidesEven  guibg=#073642 ctermbg=4",
        })
    end,
}
