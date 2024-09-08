return {
    "nathanaelkane/vim-indent-guides",
    event = { "BufReadPre", "BufNewFile" },
    init = function()
        vim.g.indent_guides_enable_on_vim_startup = 1
        vim.g.indent_guides_color_change_percent = 5
    end,
}
