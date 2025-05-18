vim.lsp.config("pylsp", {
    settings = {
        pylsp = {
            plugins = {
                -- configurationSources = { "flake8", "mypy" },
                autopep8 = { enabled = false },
                flake8 = { enabled = false },
                pyflakes = { enabled = false },
                yapf = { enabled = false },
                pycodestyle = { enabled = false },
                isort = { enabled = false },
                pylsp_black = { enabled = false },
                pylsp_mypy = {
                    enabled = true,
                    report_progress = true,
                    live_mode = false,
                },
                pylint = { enabled = false },
                pylint_lint = { enabled = false },
                ruff = { enabled = false },
                mccabe = { enabled = false },
                rope_autoimport = { enabled = false },
                jedi_completion = { enabled = false },
                jedi_definition = { enabled = false },
                jedi_hover = { enabled = false },
                jedi_references = { enabled = false },
                jedi_signature_help = { enabled = false },
                jedi_symbols = { enabled = false },
            },
        },
    },
})
--            capabilities = capabilities,
--            on_attach = on_attach,
--            on_init = function(client)
--                -- https://github.com/neovim/nvim-lspconfig/wiki/Project-local-settings#configure-in-your-personal-settings-initlua
--                local path = client.workspace_folders[1].name

--                -- see lua pattern matching: https://www.lua.org/pil/20.2.html
--                if string.find(path, "git/cmk%-app") ~= nil then
--                    client.config.settings.pylsp.plugins.pylint_lint.enabled = false
--                    client.config.settings.pylsp.plugins.pylsp_black.enabled = false
--                    client.config.settings.pylsp.plugins.isort.enabled = false
--                    client.config.settings.pylsp.plugins.ruff.enabled = true
--                    client.config.settings.pylsp.plugins.ruff.format_enabled = true
--                elseif string.find(path, "git/checkmk") ~= nil then
--                    client.config.settings.pylsp.plugins.pylint.enabled = false
--                    client.config.settings.pylsp.plugins.pylint_lint.enabled = false
--                    client.config.settings.pylsp.plugins.pylsp_black.enabled = false
--                    client.config.settings.pylsp.plugins.ruff.enabled = false
--                    client.config.settings.pylsp.plugins.isort.enabled = false
--                    client.config.settings.pylsp.plugins.yapf.enabled = false
--                elseif string.find(path, "git/checkmk%-2%.1%.0") ~= nil then
--                    client.config.settings.pylsp.plugins.pylint.enabled = true
--                    client.config.settings.pylsp.plugins.pylint_lint.enabled = true
--                    client.config.settings.pylsp.plugins.ruff.enabled = false
--                    -- client.config.settings.pylsp.plugins.pylint_lint.args = {'-j', '0', '--rcfile', '/home/lm/git/checkmk-2.1.0/.pylintrc'}
--                    -- client.config.settings.pylsp.plugins.isort.executable = path + '/scripts/run-isort'
--                    client.config.settings.pylsp.plugins.pylsp_black.enabled = false
--                    client.config.settings.pylsp.plugins.isort.enabled = false
--                elseif
--                    string.find(path, "git/checkmk%-2%.0%.0") ~= nil
--                    or string.find(path, "git/checkmk%-1%.") ~= nil
--                then
--                    client.config.settings.pylsp.plugins.pylint.enabled = true
--                    client.config.settings.pylsp.plugins.pylint_lint.enabled = true
--                    client.config.settings.pylsp.plugins.ruff.enabled = false
--                    client.config.settings.pylsp.plugins.yapf.enabled = true
--                    client.config.settings.pylsp.plugins.pylsp_black.enabled = false
--                elseif string.find(path, "git/cma") ~= nil then
--                    client.config.settings.pylsp.plugins.pylint.enabled = true
--                    client.config.settings.pylsp.plugins.pylint_lint.enabled = true
--                    client.config.settings.pylsp.plugins.ruff.enabled = false
--                    client.config.settings.pylsp.plugins.jedi.extra_paths = {
--                        "/home/lm/git/cma/packages/cma",
--                        "/home/lm/git/cma/packages/cmabackup",
--                        "/home/lm/git/cma/packages/cmk",
--                        "/home/lm/git/cma/packages/livestatus",
--                        "/home/lm/git/cma/packages/setup",
--                        "/home/lm/git/cma/packages/webconf",
--                    }
--                elseif string.find(path, "git/opentelemetry") ~= nil then
--                    client.config.settings.pylsp.plugins.pylsp_black.enabled = false
--                    client.config.settings.pylsp.plugins.isort.enabled = false
--                    client.config.settings.pylsp.plugins.ruff.enabled = false
--                    client.config.settings.pylsp.plugins.ruff.format_enabled = false
--                    client.config.settings.pylsp.plugins.pylint.args =
--                        { "-j4", "--rcfile=/home/lm/git/opentelemetry-python/.pylintrc" }
--                    client.config.settings.pylsp.plugins.pylsp_mypy.enabled = false
--                    client.config.settings.pylsp.plugins.pylsp_mypy.config_sub_paths = {
--                        "/home/lm/git/opentelemetry-python/mypy.ini",
--                    }
--                else
--                    -- enforce the default settings
--                    client.config.settings.pylsp.plugins.yapf.enabled = false
--                    client.config.settings.pylsp.plugins.pylsp_black.enabled = true
--                end

--                -- print the pylsp settings to the log
--                -- vim.notify(vim.inspect(client.config.settings.pylsp))

--                client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
--                return true
--            end,
--        })
--

vim.lsp.config("ltex", {
    settings = {
        -- https://valentjn.github.io/ltex/settings.html
        ltex = {
            enabled = {
                -- defaults
                "bib",
                "gitcommit",
                "markdown",
                "org",
                "plaintex",
                "rst",
                "rnoweb",
                "tex",
                "pandoc",
                "quarto",
                "rmd",
                -- added by me
                -- disabled for now. Is a bit too annoying. Needs tuning.
                -- "python",
            },
        },
    },
})

vim.lsp.enable({
    "jedi-language-server",
    "ruff",
    "pylsp",
    "ltex-lsp",
})

require("mason").setup()

require("which-key").add({
    -- Not used / supported by my lsp so far
    -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    -- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)

    {
        "<leader>d",
        vim.lsp.buf.definition,
        desc = "Go to definition",
    },
    { "<leader>wd", vim.lsp.buf.hover, desc = "Show documentation" },
    { "<leader>wa", vim.lsp.buf.code_action, desc = "Code action" },

    -- Conflicts with vim.diagnostic.goto_prev (see above)
    -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)

    { "<leader>wc", vim.lsp.buf.references, desc = "Find references" },
}, { buffer = bufnr })
