return {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    --ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    event = {
        "BufReadPre " .. vim.fn.expand("~") .. "/Notes/*.md",
        "BufNewFile " .. vim.fn.expand("~") .. "/Notes/*.md",
    },
    dependencies = {
        -- Required.
        "nvim-lua/plenary.nvim",
        -- see https://github.com/epwalsh/obsidian.nvim?tab=readme-ov-file#plugin-dependencies
        "hrsh7th/nvim-cmp",
        "ibhagwan/fzf-lua",
        "nvim-treesitter",
    },
    opts = {
        workspaces = {
            {
                name = "Notes",
                path = "~/Notes",
            },
        },
        -- see for full list of options:
        -- https://github.com/epwalsh/obsidian.nvim?tab=readme-ov-file#configuration-options
        picker = {
            -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
            name = "fzf-lua",
            -- Optional, configure key mappings for the picker. These are the defaults.
            -- Not all pickers support all mappings.
            --note_mappings = {
            --    -- Create a new note from your query.
            --    new = "<C-x>",
            --    -- Insert a link to the selected note.
            --    insert_link = "<C-l>",
            --},
            --tag_mappings = {
            --    -- Add tag(s) to current note.
            --    tag_note = "<C-x>",
            --    -- Insert a tag at the current location.
            --    insert_tag = "<C-l>",
            --},
        },
    },
}
