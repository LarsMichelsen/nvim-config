local on_attach_navic = function(client, bufnr)
    if client.server_capabilities.documentSymbolProvider then
        require("nvim-navic").attach(client, bufnr)
    end
end

return {
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        config = function()
            require("mason-tool-installer").setup({
                ensure_installed = {
                    -- lua
                    "stylua", -- formatter
                    -- shell
                    "shfmt", -- formatter
                    "shellcheck", -- linter
                    -- yaml
                    "yamllint", -- linter
                    -- containers
                    "hadolint", -- linter
                },
            })

            vim.api.nvim_create_autocmd("User", {
                pattern = "MasonToolsStartingInstall",
                callback = function()
                    vim.schedule(function()
                        print("mason-tool-installer is starting")
                    end)
                end,
            })

            vim.api.nvim_create_autocmd("User", {
                pattern = "MasonToolsUpdateCompleted",
                callback = function(e)
                    vim.schedule(function()
                        print(vim.inspect(e.data)) -- print the table that lists the programs that were installed
                    end)
                end,
            })
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "williamboman/mason.nvim",
        },
        opts = function(_, opts)
            opts.ensure_installed = {
                -- python
                "pylsp",
                -- lua
                "lua_ls",
                -- shell
                "bashls",
                -- containers
                "dockerls",
                -- Documents, spell and grammar checking
                "ltex",
            }
        end,
        config = function(_, opts)
            require("mason").setup({
                PATH = "append",
            })

            require("mason-lspconfig").setup(opts)

            -- See also:
            --   https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
            --   https://github.com/neovim/nvim-lspconfig/wiki/Project-local-settings
            --
            -- TODO:
            --   https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization
            --
            -- Install dependencies:
            --   pip install python-lsp-server python-lsp-server[all] pylsp-mypy pyls-isort python-lsp-black

            -- Key mappings
            -- Based on: https://github.com/neovim/nvim-lspconfig#suggested-configuration
            -- See `:help vim.diagnostic.*` for documentation on any of the below functions

            -- Use an on_attach function to only setup things after the language server
            -- attaches to the current buffer
            local on_attach = function(client, bufnr)
                on_attach_navic(client, bufnr)

                -- Restore gqq
                vim.api.nvim_buf_set_option(bufnr, "formatexpr", "")

                -- Enable completion triggered by <c-x><c-o>
                vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

                -- Mappings.
                require("which-key").register({
                    ["<C-k>"] = { vim.diagnostic.goto_prev, "Previous finding" },
                    ["<C-j>"] = { vim.diagnostic.goto_next, "Next finding" },

                    -- Not used / supported by my lsp so far
                    -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
                    -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
                    -- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)

                    ["<leader>d"] = { vim.lsp.buf.definition, "Go to definition" },
                    ["<leader>wd"] = { vim.lsp.buf.hover, "Show documentation" },
                    ["<leader>wa"] = { vim.lsp.buf.code_action, "Code action" },

                    -- Conflicts with vim.diagnostic.goto_prev (see above)
                    -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)

                    -- No idea what to do with them
                    -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
                    -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
                    -- vim.keymap.set('n', '<space>wl', function()
                    --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    -- end, bufopts)

                    -- Using native vim feature
                    --["<leader>rn"] = { vim.lsp.buf.rename, "Rename" },
                    --vim.keymap.set("n", "<space>ca", function()
                    --    vim.lsp.buf.code_action({ apply = true })
                    --end, bufopts)

                    ["<leader>wc"] = { vim.lsp.buf.references, "Find references" },

                    -- No need to trigger manually - doing format on save (see below)
                    --["<leader>f"] = { vim.lsp.buf.formatting, "Format" },
                }, { buffer = bufnr })

                -- Run formatting automatically on save
                local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
                vim.api.nvim_create_autocmd("BufWritePre", {
                    pattern = "*",
                    group = augroup,
                    callback = function()
                        vim.lsp.buf.format({
                            timeout_ms = 2000,
                            filter = function(clients)
                                return vim.tbl_filter(function(client)
                                    return pcall(function(_client)
                                        return _client.config.settings.autoFixOnSave or false
                                    end, client) or false
                                end, clients)
                            end,
                        })
                    end,
                })

                -- open diagnostic on cursor position
                vim.api.nvim_create_autocmd("CursorHold", {
                    buffer = bufnr,
                    callback = function()
                        local opts = {
                            focusable = false,
                            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                            -- border = 'rounded',
                            source = "always",
                            prefix = " ",
                            scope = "cursor",
                        }
                        vim.diagnostic.open_float(nil, opts)
                    end,
                })
            end

            -- Set up cmp with lspconfig
            local capabilities = vim.tbl_deep_extend(
                "force",
                vim.lsp.protocol.make_client_capabilities(),
                require("cmp_nvim_lsp").default_capabilities()
            )

            require("lspconfig").pylsp.setup({
                -- For debugging: tail -f /home/lm/.local/state/nvim/pylsp.log
                cmd = { "pylsp", "-v", "--log-file", "/home/lm/.local/state/nvim/pylsp.log" },
                -- format = { timeout_ms = 3000 },
                capabilities = capabilities,
                settings = {
                    pylsp = {
                        plugins = {
                            -- configurationSources = { "flake8", "mypy" },
                            autopep8 = { enabled = false },
                            flake8 = { enabled = false },
                            pyflakes = { enabled = false },
                            yapf = { enabled = false },
                            pycodestyle = { enabled = false },
                            isort = { enabled = true },
                            pylsp_black = { enabled = true },
                            pylsp_mypy = { enabled = true },
                            pylint_lint = { enabled = true },
                            pylsp_ruff = { enabled = false },
                            mccabe = { enabled = false },
                            rope_autoimport = { enabled = false },
                            jedi = { enabled = false },
                        },
                    },
                },
                capabilities = capabilities,
                on_attach = on_attach,
                on_init = function(client)
                    -- https://github.com/neovim/nvim-lspconfig/wiki/Project-local-settings#configure-in-your-personal-settings-initlua
                    local path = client.workspace_folders[1].name

                    if string.find(path, "git/cmk-app") ~= nil then
                        client.config.settings.pylsp.plugins.pylint_lint.enabled = false
                        client.config.settings.pylsp.plugins.pylsp_ruff.enabled = true
                    elseif string.find(path, "git/checkmk-2.1.0") ~= nil then
                    -- client.config.settings.pylsp.plugins.pylint_lint.args = {'-j', '0', '--rcfile', '/home/lm/git/checkmk-2.1.0/.pylintrc'}
                    -- client.config.settings.pylsp.plugins.isort.executable = path + '/scripts/run-isort'
                    elseif
                        string.find(path, "git/checkmk-2.0.0") ~= nil or string.find(path, "git/checkmk-1.") ~= nil
                    then
                        client.config.settings.pylsp.plugins.yapf.enabled = true
                        client.config.settings.pylsp.plugins.pylsp_black.enabled = false
                    elseif string.find(path, "git/cma") ~= nil then
                        -- client.config.settings.pylsp.plugins.yapf.enabled = true
                        client.config.settings.pylsp.plugins.jedi.extra_paths = {
                            "/home/lm/git/cma/packages/cma",
                            "/home/lm/git/cma/packages/cmabackup",
                            "/home/lm/git/cma/packages/cmk",
                            "/home/lm/git/cma/packages/livestatus",
                            "/home/lm/git/cma/packages/setup",
                            "/home/lm/git/cma/packages/webconf",
                        }
                    else
                        -- enforce the default settings
                        client.config.settings.pylsp.plugins.yapf.enabled = false
                        client.config.settings.pylsp.plugins.pylsp_black.enabled = true
                    end

                    client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
                    return true
                end,
            })
            -- I don't like displaying the "virtual text" on the code - too much visual clutter for me
            vim.lsp.handlers["textDocument/publishDiagnostics"] =
                vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
                    virtual_text = false,
                })

            -- Change diagnostic symbols in the sign column (gutter)
            local signs = { Error = "✖ ", Warn = "⚠ ", Hint = "H ", Info = "I " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end

            -- Python 3.11 currently not supported
            -- https://github.com/pappasam/jedi-language-server
            -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#jedi_language_server
            -- require('lspconfig').jedi_language_server.setup{
            --   settings = {
            --
            --   },
            --   on_attach = on_attach
            -- }

            -- Check which capabilities a LSP has:
            -- :lua =vim.lsp.get_active_clients()[1].server_capabilities

            -- Enable this, then see :LspLog
            -- or `tail -f /home/lm/.local/state/nvim/lsp.log`
            -- :lua vim.lsp.set_log_level("debug")

            --
            -- Open definition in new tab
            --
            local api = vim.api
            local util = vim.lsp.util
            local log = require("vim.lsp.log")

            local function location_handler(_, result, ctx, config)
                if result == nil or vim.tbl_isempty(result) then
                    local _ = log.info() and log.info(ctx.method, "No location found")
                    return nil
                end
                local client = vim.lsp.get_client_by_id(ctx.client_id)

                config = config or { reuse_win = true }

                -- textDocument/definition can return Location or Location[]
                -- https://microsoft.github.io/language-server-protocol/specifications/specification-current/#textDocument_definition

                -- create a new tab and save bufnr
                api.nvim_command("tabnew")
                local buf = api.nvim_get_current_buf()

                if vim.tbl_islist(result) then
                    local title = "LSP locations"
                    local items = util.locations_to_items(result, client.offset_encoding)

                    if config.on_list then
                        assert(type(config.on_list) == "function", "on_list is not a function")
                        config.on_list({ title = title, items = items })
                    else
                        if #result == 1 then
                            util.jump_to_location(result[1], client.offset_encoding, config.reuse_win)
                        else
                            vim.fn.setqflist({}, " ", { title = title, items = items })
                            api.nvim_command("botright copen")
                        end
                    end
                else
                    util.jump_to_location(result, client.offset_encoding, config.reuse_win)
                    local buf = api.nvim_get_current_buf()
                end

                -- remove the empty buffer created with tabnew
                api.nvim_command(buf .. "bd")
            end

            vim.lsp.handlers["textDocument/declaration"] = location_handler
            vim.lsp.handlers["textDocument/definition"] = location_handler
            vim.lsp.handlers["textDocument/typeDefinition"] = location_handler
            vim.lsp.handlers["textDocument/implementation"] = location_handler

            -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#ltex
            require("lspconfig").ltex.setup({
                filetypes = {
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
                    "python",
                },
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    on_attach(client, bufnr)
                    require("ltex_extra").setup({
                        -- Where to store dictionaries?
                        path = vim.fn.expand("~") .. "/.local/share/nvim/ltex",
                    })
                end,
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
        end,
    },
    {
        "neovim/nvim-lspconfig",
    },
    {
        -- https://github.com/linrongbin16/lsp-progress.nvim
        "linrongbin16/lsp-progress.nvim",
        config = function()
            require("lsp-progress").setup({
                -- Show all active client names
                -- https://github.com/linrongbin16/lsp-progress.nvim/wiki/Advanced-Configuration
                client_format = function(client_name, spinner, series_messages)
                    if #series_messages == 0 then
                        return nil
                    end
                    return {
                        name = client_name,
                        body = spinner .. " " .. table.concat(series_messages, ", "),
                    }
                end,
                format = function(client_messages)
                    --- @param name string
                    --- @param msg string?
                    --- @return string
                    local function stringify(name, msg)
                        return msg and string.format("%s %s", name, msg) or name
                    end

                    local sign = "" -- nf-fa-gear \uf013
                    local lsp_clients = vim.lsp.get_active_clients()
                    local messages_map = {}
                    for _, climsg in ipairs(client_messages) do
                        messages_map[climsg.name] = climsg.body
                    end

                    if #lsp_clients > 0 then
                        table.sort(lsp_clients, function(a, b)
                            return a.name < b.name
                        end)
                        local builder = {}
                        for _, cli in ipairs(lsp_clients) do
                            if type(cli) == "table" and type(cli.name) == "string" and string.len(cli.name) > 0 then
                                if messages_map[cli.name] then
                                    table.insert(builder, stringify(cli.name, messages_map[cli.name]))
                                else
                                    table.insert(builder, stringify(cli.name))
                                end
                            end
                        end
                        if #builder > 0 then
                            return sign .. " " .. table.concat(builder, ", ")
                        end
                    end
                    return ""
                end,
            })
        end,
    },
    {
        -- https://github.com/stevearc/conform.nvim
        -- https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md
        -- See also :ConformInfo and ~/.local/state/nvim/conform.log
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        opts = {
            log_level = vim.log.levels.DEBUG,
            formatters_by_ft = {
                -- Done by pylsp
                -- python = { "isort", "black" },
                lua = { "stylua" },
                sh = { "shfmt" },
                yaml = { "prettier" },
                --sql = { "sqlfluff" },
                --rust = { "rustfmt" },
                --go = { "gofumpt", "goimports", "gci" },
                --protobuf = { "buf" },
                dockerfile = { "hadolint" },
                --dockercompose = { "docker-compose" },
            },
            -- Set up format-on-save
            format_on_save = { timeout_ms = 500, lsp_fallback = false },
            -- Customize formatters
            formatters = {
                stylua = {
                    prepend_args = { "--indent-type", "Spaces", "--indent-width", "4" },
                },
                shfmt = {
                    prepend_args = { "-ci", "-i", "4" },
                },
            },
        },
    },
    {
        -- https://github.com/mfussenegger/nvim-lint
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lint = require("lint")

            lint.linters_by_ft = {
                sh = { "shellcheck" },
                yaml = { "yamllint" },
            }

            local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

            vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
                group = lint_augroup,
                callback = function()
                    lint.try_lint()
                end,
            })
        end,
    },
    {
        "SmiteshP/nvim-navic",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "neovim/nvim-lspconfig" },
    },
    { "barreiroleo/ltex-extra.nvim" },
}
