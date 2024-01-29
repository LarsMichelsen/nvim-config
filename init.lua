-- Works for me :-)
--
-- Useful shortcuts
--
-- - Fuzzy file search: CTRL+s (full screen)
-- - File history: CTRL+h
-- - Go to definition: ,d
-- - List references: gr
-- - Open link in browser: gx
-- - Show documentation/docstring: SHIFT+K
-- - Git log of current buffer: CTRL+l
-- - Jump linter findings CTRL+k, CTRL+j
-- - Toggle dark/light: F10
-- - Deploy: F12

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Set before loading lazy to ensure keybinds are correct
vim.g.mapleader = ","

require("lazy").setup("plugins")

require("config/options")
require("config/autocmds")
require("config/keymaps")
