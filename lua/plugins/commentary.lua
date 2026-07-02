-- Comment things (gcc current line, gcap for paragraph, gc in visual mode)
return {
    "tpope/vim-commentary",
    lazy = false,
    keys = {
        {
            "<leader>cc",
            ":Commentary<CR>",
            desc = "Comment out line",
        },
    },
}
