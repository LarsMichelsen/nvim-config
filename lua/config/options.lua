-- See https://neovim.io/doc/user/options.html
local options = {
    incsearch = true,
    hlsearch = true,
    infercase = true,
    ignorecase = true,
    -- ignore case if search pattern is all lowercase. case-sensitive otherwise
    smartcase = true,

    -- Always show the left sign column
    signcolumn = "yes",
    -- Show line numbers on the left
    nu = true,

    -- hide launch screen
    shortmess = vim.opt["shortmess"]._value .. "I",
    -- automatically reload files changed outside of Vim
    autoread = true,
    -- change the terminal's title
    title = true,
    -- use multiple of shiftwidth when indenting with '<' and '>'
    shiftround = true,
    -- set show matching parenthesis
    showmatch = true,
    -- Don't show "-- INSERT --" in bottom line (needed for echodoc.vim)
    showmode = false,
    -- Always show some lines of context
    scrolloff = 5,

    -- Reduce delays of view updates
    updatetime = 100,
    -- Reduce delays of key sequence detection
    timeoutlen = 300,

    tabstop = 8,
    shiftwidth = 4,
    softtabstop = 4,
    smarttab = true,
    expandtab = true,
    autoindent = true,

    -- Disable mouse context menu
    mouse = "",

    -- https://neovim.io/doc/user/change.html#fo-table
    formatoptions = vim.opt["formatoptions"]._value .. "l",
    textwidth = 100,
    colorcolumn = "",

    tabpagemax = 100,

    showcmd = true,
    -- less disc io
    fsync = false,

    -- allow these keys to move around at wrapping places
    switchbuf = "usetab",
    -- make cmdline tab completion similar to bash
    whichwrap = vim.opt["whichwrap"]._value .. ",<,>,[,]",
    wildmode = "list:longest",
    wildignore = "*.swp,*.bak,*.pyc,*.class,*min.js",

    -- Use clipboard of the system for copying between vim and other processes
    -- (Do: sudo apt-get install xsel as written in :help clipboard)
    clipboard = "unnamedplus",

    spelllang = "en_us,de_de",
    spell = true,

    syntax = "on",
    termguicolors = true,

    fillchars = vim.opt["fillchars"] + { diff = "_" },
    -- diffopt = "internal,filler,closeoff,indent-heuristic,linematch:60,algorithm:histogram",
    diffopt = "internal,filler,closeoff,indent-heuristic,linematch:60,algorithm:patience",

    -- views can only be fully collapsed with the global statusline
    laststatus = 3,
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

-- Not using this, was causing warnings in :checkhealth
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- Set for obsidian.lua
vim.opt.conceallevel = 1

vim.diagnostic.config({
    signs = true,
    underline = true,
    virtual_text = false,
    virtual_lines = false,
    update_in_insert = true,
    severity_sort = true,
    float = {
        header = false,
        border = "none",
        focusable = true,
        severity = {
            min = vim.diagnostic.severity.ERROR,
        },
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "✖ ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.INFO] = "󰋼 ",
            [vim.diagnostic.severity.HINT] = "󰌵 ",
        },
        numhl = {
            [vim.diagnostic.severity.WARN] = "WarningMsg",
            [vim.diagnostic.severity.ERROR] = "ErrorMsg",
        },
        severity = {
            min = vim.diagnostic.severity.ERROR,
        },
    },
})

-- Highlight lines longer than 100
vim.api.nvim_set_hl(0, "OverLength", { bg = "#3b0000" }) -- dark red
local excluded_filetypes = {
    "markdown",
    "text",
    "help",
    "nerdtree",
    "TelescopePrompt",
    "gitcommit",
    "Avante",
}
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    callback = function()
        local ft = vim.bo.filetype
        if vim.tbl_contains(excluded_filetypes, ft) then
            return -- Skip overlength match for these filetypes
        end

        -- Add the OverLength highlight
        vim.api.nvim_set_hl(0, "OverLength", { bg = "#3b0000" })
        vim.fn.matchadd("OverLength", "\\%101v.*")
    end,
})
