--
-- Fuzzy find using fzf (Triggered using CTRL-A)
--

local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

return {
    {
        -- https://github.com/junegunn/fzf/
        "junegunn/fzf",
        lazy = false,
        build = "./install --bin",
        init = function()
            --vim.opt.runtimepath:append(',~/.fzf')
            -- Enable CTRL-N and CTRL-P for history forward/backward search in CTRL-A mode
            vim.g.fzf_history_dir = "~/.local/share/fzf-history"
            --vim.g.fzf_layout = { down = '40%' }

            --vim.g.fzf_action = {
            --  ['ctrl-m'] = 'tabedit',
            --  ['ctrl-t'] = 'tabedit',
            --  ['ctrl-h'] = 'botright split',
            --  ['ctrl-v'] = 'vertical botright split',
            --}

            -- TODO Investigate howto clean this up
            vim.cmd([[
            command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, '--smart-case -W 200 --python --markdown --yaml --cpp --ts --js --php --sass --make --rust --bazel --follow --ignore ".mypy_cache" --ignore "*_min.js" --ignore jquery --ignore agents/windows/chroot --ignore node_modules --ignore omd/packages/python-modules/destdir --ignore "livestatus" --ignore "skel/opt/omd" --color-path="0;33"', <bang>0)
            ]])
        end,
    },
    {
        "ibhagwan/fzf-lua",
        -- optional for icon support
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            -- calling `setup` is optional for customization
            require("fzf-lua").setup({
                winopts = {
                    height = 0.95,
                    width = 0.95,
                    row = 0.30,
                    col = 0.30,
                },
                files = {
                    rg_opts = '--smart-case -g "!{.git,node_modules,.mypy_cache,swagger-ui-3}/*" -g !redoc.standalone.js -g !Pipfile.lock',
                },
            })
        end,
        init = function()
            map("n", "<C-t>", "<cmd>lua require('fzf-lua').files()<CR>")
            map("n", "<C-p>", "<cmd>lua require('fzf-lua').git_files()<CR>")
            map("n", "<C-l>", "<cmd>lua require('fzf-lua').git_bcommits()<CR>")
            map("n", "<C-h>", "<cmd>lua require('fzf-lua').oldfiles()<CR>")
            map("n", "<C-a>", '<cmd>lua require("fzf-lua").live_grep_native()<CR>')
            --map('n', '<C-s>', ':Ag!<CR>')
            -- Immediately search for the word under the cursor in a new tab
            map("n", "<Leader>ag", "<cmd>lua require('fzf-lua').grep_cword()<CR>")
        end,
    },
}
