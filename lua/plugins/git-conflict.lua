return {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = true,
    disable_diagnostics = true, -- Disable the diagnostics in a buffer whilst it is conflicted
    default_mappings = false,
    init = function()
        local wk = require("which-key")
        wk.add({
            { "ck", "<cmd>GitConflictChooseOurs<CR>", desc = "Choose ours" },
            { "cj", "<cmd>GitConflictChooseTheirs<CR>", desc = "Choose theirs" },
            { "cb", "<cmd>GitConflictChooseBoth<CR>", desc = "Choose both" },
            { "c0", "<cmd>GitConflictChooseNone<CR>", desc = "Choose none" },
            { "[x", "<cmd>GitConflictPrevConflict<CR>", desc = "Previous conflict" },
            { "]x", "<cmd>GitConflictNextConflict<CR>", desc = "Next conflict" },
        })
    end,
}
