return {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    opts = {
        options = {
            mode = "tabs",
            always_show_bufferline = true,
            show_buffer_close_icons = false,
            show_tab_indicators = false,
            show_close_icon = false,
            diagnostics = "nvim_lsp",
            diagnostics_indicator = function(_, _, diag)
                local indicator = (diag.error and "✖" .. " " or "") .. (diag.warning and "?" or "")
                return vim.trim(indicator)
            end,
        },
    },
}
