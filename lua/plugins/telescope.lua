return {
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        version = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                config = function()
                    require("telescope").load_extension("fzf")
                end,
            },
        },
        init = function()
            local wk = require("which-key")
            local builtin = require("telescope.builtin")
            wk.add({
                { "<C-a>", builtin.live_grep, desc = "Live grep" },
                { "<C-s>", builtin.resume, desc = "Resume last search" },
                { "<C-b>", builtin.buffers, desc = "Find buffers" },
                { "<C-h>", builtin.oldfiles, desc = "Recent files" },
                { "<C-l>", builtin.git_bcommits, desc = "Find git commits" },
                { "<C-p>", builtin.git_files, desc = "Find git files" },
                { "<C-t>", builtin.find_files, desc = "Find files" },
                --{ "<leader>wf", builtin.lsp_references, desc = "Find word under cursor" },
                { "<leader>wf", builtin.grep_string, desc = "Find word under cursor" },
            })
        end,
        opts = function()
            local actions = require("telescope.actions")
            return {
                defaults = {
                    layout_strategy = "horizontal",
                    layout_config = {
                        horizontal = {
                            width = 0.98,
                            height = 0.98,
                            preview_height = 0.5,
                        },
                    },
                },
            }
        end,
    },
}
