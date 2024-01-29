return {
    -- Was visually too noisy for me. I also prefer to have blames on the side for multiple lines at
    -- once which the plugin could not deliver
    --{
    --    -- https://github.com/f-person/git-blame.nvim
    --    "f-person/git-blame.nvim",
    --    keys = {
    --        -- toggle needs to be called twice; https://github.com/f-person/git-blame.nvim/issues/16
    --        { "<leader>gbe", ":GitBlameEnable<CR>", desc = "Blame line (enable)" },
    --        { "<leader>gbd", ":GitBlameDisable<CR>", desc = "Blame line (disable)" },
    --        { "<leader>gbs", ":GitBlameCopySHA<CR>", desc = "Copy SHA" },
    --        { "<leader>gbc", ":GitBlameCopyCommitURL<CR>", desc = "Copy commit URL" },
    --        { "<leader>gbf", ":GitBlameCopyFileURL<CR>", desc = "Copy file URL" },
    --    },
    --    -- let g:gitblame_date_format = '%r'
    --    config = function()
    --        vim.g.gitblame_date_format = "%Y-%m-%d %H:%M"
    --        vim.g.gitblame_display_virtual_text = 0
    --    end,
    --},
    {
        "tpope/vim-fugitive",
    },
}
