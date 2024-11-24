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
    colorcolumn = "100",

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
