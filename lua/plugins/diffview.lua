return {
    "sindrets/diffview.nvim",
    lazy = false,
    config = function()
        require("diffview").setup({
            enhanced_diff_hl = true,
            use_icons = true,
            view = {
                merge_tool = {
                    -- Config for conflicted files in diff views during a merge or rebase.
                    layout = "diff3_mixed",
                    disable_diagnostics = true, -- Temporarily disable diagnostics for diff buffers while in the view.
                    winbar_info = true, -- See |diffview-config-view.x.winbar_info|
                },
            },
        })
    end,
    keys = {
        { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Open diff view" },
        { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Open file history" },
        { "<leader>gB", "<cmd>DiffviewOpen origin/HEAD...HEAD --imply-local<cr>", desc = "Review branch changes" },
        { "<leader>gc", "<cmd>DiffviewClose<CR>", desc = "close view" },
    },
}
