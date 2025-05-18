vim.cmd([[
cabbrev Wq wq
cabbrev W w
cabbrev Q q
]])

local wk = require("which-key")

function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

-- Remap j and k to act as expected when used on long, wrapped, lines
map("n", "j", "gj")
map("n", "k", "gk")

-- Use shift-H and shift-L for move to beginning/end
map("n", "H", "0")
map("n", "L", "$")

-- Speed up scrolling of the viewport slightly
map("n", "<C-e>", "3<C-e>")
map("n", "<C-y>", "3<C-y>")

-- Center screen after focussing the next search result
map("n", "n", "nzz")

map("n", "<Down>", "gj")
map("n", "<Up>", "gk")

wk.add({
    { "<C-f>", ":%s/<C-r><C-w>//g<Left><Left>", desc = "Replace word under cursor" },
    { "<F10>", ':exec &bg=="light"? "set bg=dark" : "set bg=light"<CR>', desc = "Toggle light/dark mode" },
    { "<F12>", ":w<CR>:!/home/lm/git/zeug_cmk/bin/f12 %:p<CR>", desc = "Deploy" },
    { "<leader>wr", ":%s/<C-r><C-w>//g<Left><Left>", desc = "Replace word under cursor" },
})

local current_min_severity = 1 -- Does not work for some reason: vim.diagnostic.severity.CRIT

local function toggle_diagnostic_severity()
    if current_min_severity == vim.diagnostic.severity.INFO then
        current_min_severity = vim.diagnostic.severity.ERROR
    elseif current_min_severity == vim.diagnostic.severity.WARN then
        current_min_severity = vim.diagnostic.severity.INFO
    else
        current_min_severity = vim.diagnostic.severity.WARN
    end

    local current_config = vim.diagnostic.config()
    current_config.signs = vim.tbl_deep_extend("force", current_config.signs or {}, {
        severity = {
            min = current_min_severity,
            max = vim.diagnostic.severity.ERROR,
        },
    })
    current_config.float = vim.tbl_deep_extend("force", current_config.float or {}, {
        severity = {
            min = current_min_severity,
            max = vim.diagnostic.severity.ERROR,
        },
    })
    vim.diagnostic.config(current_config)

    if current_min_severity == vim.diagnostic.severity.INFO then
        name = "INFO"
    elseif current_min_severity == vim.diagnostic.severity.WARN then
        name = "WARN"
    elseif current_min_severity == vim.diagnostic.severity.ERROR then
        name = "ERROR"
    else
        name = "CRIT"
    end

    print("Diagnostics severity set to: " .. name)
end

wk.add({
    { "<leader>tw", toggle_diagnostic_severity, desc = "Toggle diagnostic severity (WARN/ERROR)" },
    {
        "<C-k>",
        function()
            vim.diagnostic.goto_next({ severity = { current_min_severity, vim.diagnostic.severity.ERROR } })
        end,
        desc = "Previous diagnostic finding",
    },
    {
        "<C-j>",
        function()
            vim.diagnostic.goto_prev({ severity = { current_min_severity, vim.diagnostic.severity.ERROR } })
        end,
        desc = "Next diagnostic finding",
    },
})
