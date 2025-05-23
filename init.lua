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

--require("lazy").setup("plugins")
require("lazy").setup("plugins", {
    change_detection = {
        notify = false,
    },
})

require("config/options")
require("config/autocmds")
require("config/keymaps")
