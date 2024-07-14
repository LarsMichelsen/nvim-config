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
    { "<F12>", ":w<CR>:!sudo /home/lm/git/zeug_cmk/bin/f12 %:p<CR>", desc = "Deploy" },
    { "<leader>gb", ":Git blame<CR>", desc = "Git blame" },
    { "<leader>wr", ":%s/<C-r><C-w>//g<Left><Left>", desc = "Replace word under cursor" },
})
