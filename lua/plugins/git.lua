return {
    {
        "spacedentist/resolve.nvim",
        dependencies = { "folke/which-key.nvim" },
        event = { "BufReadPre", "BufNewFile" },
        keys = {
            {
                "]c",
                "<Plug>(resolve-next)",
                desc = "Next conflict",
            },
            {
                "[c",
                "<Plug>(resolve-prev)",
                desc = "Previous conflict",
            },

            {
                "<leader>co",
                "<Plug>(resolve-ours)",
                desc = "Choose ours",
            },
            {
                "<leader>ct",
                "<Plug>(resolve-theirs)",
                desc = "Choose theirs",
            },
            {
                "<leader>cb",
                "<Plug>(resolve-both)",
                desc = "Choose both",
            },
            {
                "<leader>cB",
                "<Plug>(resolve-both-reverse)",
                desc = "Choose both reverse",
            },
            {
                "<leader>cm",
                "<Plug>(resolve-base)",
                desc = "Choose base",
            },
            {
                "<leader>cn",
                "<Plug>(resolve-none)",
                desc = "Choose none",
            },

            {
                "<leader>cdo",
                "<Plug>(resolve-diff-ours)",
                desc = "Diff ours",
            },
            {
                "<leader>cdt",
                "<Plug>(resolve-diff-theirs)",
                desc = "Diff theirs",
            },
            {
                "<leader>cdb",
                "<Plug>(resolve-diff-both)",
                desc = "Diff both",
            },
            {
                "<leader>cdv",
                "<Plug>(resolve-diff-vs)",
                desc = "Diff ours → theirs",
            },
            {
                "<leader>cdV",
                "<Plug>(resolve-diff-vs-reverse)",
                desc = "Diff theirs → ours",
            },

            {
                "<leader>cl",
                "<Plug>(resolve-list)",
                desc = "List conflicts",
            },
        },
        opts = {
            default_keymaps = false,
        },
        config = function(_, opts)
            require("resolve").setup(opts)
            require("which-key").add({
                { "<leader>c", group = "Git Conflicts" },
                { "<leader>cd", group = "Diff" },
            })
        end,
    },
    {
        "FabijanZulj/blame.nvim",
        lazy = false,
        keys = {
            {
                "<leader>gb",
                ":BlameToggle<CR>",
                desc = "Blame",
            },
        },
        opts = {
            date_format = "%Y-%m-%d",
        },
    },
}
