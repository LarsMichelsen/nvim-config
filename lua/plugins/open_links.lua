return {
    "chrishrb/gx.nvim",
    keys = {
        { "<leader>wb", "<cmd>Browse<cr>", mode = { "n", "x" }, desc = "Open in browser" },
    },
    cmd = { "Browse" },
    init = function()
        vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("gx").setup({
            open_browser_app = "xdg-open",
            handlers = {
                plugin = true, -- open plugin links in lua (e.g. packer, lazy, ..)
                github = true, -- open github issues
                package_json = true, -- open dependencies from package.json
                search = true, -- search the web/selection on the web if nothing else is found
            },
            handler_options = {
                search_engine = "google",
            },
        })
    end,
}
