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
                    -- python
                    --"basedpyright", -- typing
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
                        -- print(vim.inspect(e.data)) -- print the table that lists the programs that were installed
                    end)
                end,
            })
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            --"hrsh7th/cmp-nvim-lsp",
            "williamboman/mason.nvim",
            -- https://cmp.saghen.dev/installation.html
            "saghen/blink.cmp",
        },
        opts = function(_, opts)
            opts.ensure_installed = {
                -- python
                "pylsp",
                "jedi_language_server",
                "ruff",
                --"basedpyright",
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

                -- Clear diagnostics on save, and trigger LSP to compute them again
                vim.api.nvim_create_autocmd({ "BufWritePre" }, {
                    pattern = "*", -- This applies to all file types
                    callback = function()
                        local buf = vim.api.nvim_get_current_buf()
                        -- Check if buffer is actually modified, and only if it is modified,
                        local buf_modified = vim.api.nvim_buf_get_option(buf, "modified")
                        if buf_modified then
                            -- Reset diagnostics before save
                            vim.diagnostic.reset()
                        end
                    end,
                })

                --
                -- Open definition in new tab
                --
                --local function on_list_handler(options)
                --    -- Sample structure
                --    -- options = { ["context"] = { ["method"] = textDocument/definition,["bufnr"] = 1,} ,["title"] = LSP locations,["items"] = { [1] = { ["lnum"] = 93,["filename"] = /home/lm/git/checkmk/cmk/gui/config.py,["user_data"] = { ["range"] = { ["end"] = { ["line"] = 92,["character"] = 13,} ,["start"] = { ["line"] = 92,["character"] = 0,} ,} ,["uri"] = file:///home/lm/git/checkmk/cmk/gui/config.py,} ,["text"] = active_config = request_local_attr("config", Config),["col"] = 1,["end_col"] = 14,["end_lnum"] = 93,} ,} ,}
                --    local api = vim.api
                --    local log = require("vim.lsp.log")

                --    local result = options.items
                --    if result == nil or vim.tbl_isempty(result) then
                --        local _ = log.info() and log.info("No location found")
                --        return nil
                --    end

                --    -- create a new tab and save bufnr
                --    vim.cmd("tabnew")
                --    local buf = api.nvim_get_current_buf()

                --    if #result == 1 then
                --        --util.jump_to_location(result.items[1], client.offset_encoding, true)
                --        local item = result[1]
                --        local win = api.nvim_get_current_win()
                --        local b = item.bufnr or vim.fn.bufadd(item.filename)

                --        -- Save position in jumplist
                --        vim.cmd("normal! m'")
                --        -- Push a new item into tagstack
                --        local tagstack = { { tagname = tagname, from = from } }
                --        vim.fn.settagstack(vim.fn.win_getid(win), { items = tagstack }, "t")

                --        vim.bo[b].buflisted = true
                --        local w = vim.fn.win_findbuf(b)[1] or win
                --        api.nvim_win_set_buf(w, b)
                --        api.nvim_win_set_cursor(w, { item.lnum, item.col - 1 })
                --        vim._with({ win = w }, function()
                --            -- Open folds under the cursor
                --            vim.cmd("normal! zv")
                --        end)
                --    else
                --        vim.fn.setqflist({}, " ", { title = title, items = items })
                --        api.nvim_command("botright copen")
                --    end

                --    -- remove the empty buffer created with tabnew
                --    api.nvim_command(buf .. "bd")
                --end

                -- Mappings.
                require("which-key").add({
                    -- Not used / supported by my lsp so far
                    -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
                    -- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)

                    {
                        "<leader>d",
                        vim.lsp.buf.definition,
                        desc = "Go to definition",
                    },
                    -- Open definition in new tab
                    --{
                    --    "<leader>d",
                    --    function()
                    --        require("vim.lsp.log").warn("====================== Y")
                    --        vim.lsp.buf.definition({ on_list = on_list_handler })
                    --    end,
                    --    --vim.lsp.buf.definition,
                    --    desc = "Go to definition",
                    --},
                    { "<leader>wd", vim.lsp.buf.hover, desc = "Show documentation" },
                    { "<leader>wa", vim.lsp.buf.code_action, desc = "Code action" },

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

                    { "<leader>wc", vim.lsp.buf.references, desc = "Find references" },
                }, { buffer = bufnr })
            end

            local lspconfig = require("lspconfig")

            -- Extend capabilities for blink LSP integration (See
            -- https://cmp.saghen.dev/installation.html)
            local capabilities = vim.tbl_deep_extend(
                "force",
                vim.lsp.protocol.make_client_capabilities(),
                --require("cmp_nvim_lsp").default_capabilities()
                require("blink.cmp").get_lsp_capabilities()
            )

            --require("lspconfig").basedpyright.setup({
            --    capabilities = capabilities,
            --    on_attach = on_attach,
            --    single_file_support = true,
            --    settings = {
            --        basedpyright = {
            --            analysis = {
            --                autoSearchPaths = true,
            --                useLibraryCodeForTypes = true,
            --                diagnosticMode = "openFilesOnly",
            --                exclude = {
            --                    "bazel-bin",
            --                    "bazel-checkmk-*",
            --                    "bazel-checkmk",
            --                    "bazel-out",
            --                    "**/.cache",
            --                    "**/.venv",
            --                    "**/node_modules",
            --                    "**/.cargo",
            --                    "**/.mypy_cache",
            --                    ".git",
            --                },
            --            },
            --        },
            --    },
            --})

            -- https://github.com/pappasam/jedi-language-server?tab=readme-ov-file#configuration
            lspconfig.jedi_language_server.setup({
                cmd = {
                    -- Needs ":PylspInstall pylsp-mypy python-lsp-ruff" to make the plugins
                    -- available in the mason provided venv.
                    vim.fn.stdpath("data") .. "/mason/bin/jedi-language-server",
                    -- For debugging
                    --"-v",
                    --"--log-file",
                    --"/home/lm/.local/state/nvim/jedi.log",
                },
                init_options = {
                    -- add language server options here
                    --jediSettings = { debug = true },
                    hover = { enable = false },
                    diagnostics = { enable = false },
                },
                capabilities = capabilities,
            })

            lspconfig.pylsp.setup({
                -- For debugging: tail -f /home/lm/.local/state/nvim/pylsp.log
                cmd = {
                    -- Needs ":PylspInstall pylsp-mypy python-lsp-ruff" to make the plugins
                    -- available in the mason provided venv.
                    vim.fn.stdpath("data") .. "/mason/bin/pylsp",
                    --"pylsp",
                    --"-v",
                    --"--log-file",
                    --"/home/lm/.local/state/nvim/pylsp.log",
                },
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
                            ruff = { enabled = true },
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
                capabilities = capabilities,
                on_attach = on_attach,
                on_init = function(client)
                    -- https://github.com/neovim/nvim-lspconfig/wiki/Project-local-settings#configure-in-your-personal-settings-initlua
                    local path = client.workspace_folders[1].name

                    -- see lua pattern matching: https://www.lua.org/pil/20.2.html
                    if string.find(path, "git/cmk%-app") ~= nil then
                        client.config.settings.pylsp.plugins.pylint_lint.enabled = false
                        client.config.settings.pylsp.plugins.pylsp_black.enabled = false
                        client.config.settings.pylsp.plugins.isort.enabled = false
                        client.config.settings.pylsp.plugins.ruff.enabled = true
                        client.config.settings.pylsp.plugins.ruff.format_enabled = true
                    elseif string.find(path, "git/checkmk") ~= nil then
                        client.config.settings.pylsp.plugins.pylint.enabled = false
                        client.config.settings.pylsp.plugins.pylint_lint.enabled = false
                        client.config.settings.pylsp.plugins.pylsp_black.enabled = false
                        client.config.settings.pylsp.plugins.ruff.enabled = true
                        client.config.settings.pylsp.plugins.isort.enabled = false
                        client.config.settings.pylsp.plugins.yapf.enabled = false
                    elseif string.find(path, "git/checkmk%-2%.1%.0") ~= nil then
                        client.config.settings.pylsp.plugins.pylint.enabled = true
                        client.config.settings.pylsp.plugins.pylint_lint.enabled = true
                        client.config.settings.pylsp.plugins.ruff.enabled = false
                        -- client.config.settings.pylsp.plugins.pylint_lint.args = {'-j', '0', '--rcfile', '/home/lm/git/checkmk-2.1.0/.pylintrc'}
                        -- client.config.settings.pylsp.plugins.isort.executable = path + '/scripts/run-isort'
                        client.config.settings.pylsp.plugins.pylsp_black.enabled = false
                        client.config.settings.pylsp.plugins.isort.enabled = false
                    elseif
                        string.find(path, "git/checkmk%-2%.0%.0") ~= nil
                        or string.find(path, "git/checkmk%-1%.") ~= nil
                    then
                        client.config.settings.pylsp.plugins.pylint.enabled = true
                        client.config.settings.pylsp.plugins.pylint_lint.enabled = true
                        client.config.settings.pylsp.plugins.ruff.enabled = false
                        client.config.settings.pylsp.plugins.yapf.enabled = true
                        client.config.settings.pylsp.plugins.pylsp_black.enabled = false
                    elseif string.find(path, "git/cma") ~= nil then
                        client.config.settings.pylsp.plugins.pylint.enabled = true
                        client.config.settings.pylsp.plugins.pylint_lint.enabled = true
                        client.config.settings.pylsp.plugins.ruff.enabled = false
                        client.config.settings.pylsp.plugins.jedi.extra_paths = {
                            "/home/lm/git/cma/packages/cma",
                            "/home/lm/git/cma/packages/cmabackup",
                            "/home/lm/git/cma/packages/cmk",
                            "/home/lm/git/cma/packages/livestatus",
                            "/home/lm/git/cma/packages/setup",
                            "/home/lm/git/cma/packages/webconf",
                        }
                    elseif string.find(path, "git/opentelemetry") ~= nil then
                        client.config.settings.pylsp.plugins.pylsp_black.enabled = false
                        client.config.settings.pylsp.plugins.isort.enabled = false
                        client.config.settings.pylsp.plugins.ruff.enabled = false
                        client.config.settings.pylsp.plugins.ruff.format_enabled = false
                        client.config.settings.pylsp.plugins.pylint.args =
                            { "-j4", "--rcfile=/home/lm/git/opentelemetry-python/.pylintrc" }
                        client.config.settings.pylsp.plugins.pylsp_mypy.enabled = false
                        client.config.settings.pylsp.plugins.pylsp_mypy.config_sub_paths = {
                            "/home/lm/git/opentelemetry-python/mypy.ini",
                        }
                    else
                        -- enforce the default settings
                        client.config.settings.pylsp.plugins.yapf.enabled = false
                        client.config.settings.pylsp.plugins.pylsp_black.enabled = true
                    end

                    -- print the pylsp settings to the log
                    -- vim.notify(vim.inspect(client.config.settings.pylsp))

                    client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
                    return true
                end,
            })

            -- organizeImports does not work at the moment. Using ruff_* of conform for now.
            -- require("lspconfig").ruff.setup({
            --     trace = "messages",
            --     init_options = {
            --         settings = {
            --             -- organizeImports does not seem to work at the moment. Falling back to
            --             -- conform for now.
            --             organizeImports = false,
            --             fixAll = true,
            --             -- logLevel = "debug",
            --             --logFile = "/home/lm/.local/state/nvim/ruff.log",
            --             -- :lua vim.print(vim.lsp.get_log_path())
            --         },
            --     },
            --     on_init = function(client)
            --         -- https://github.com/neovim/nvim-lspconfig/wiki/Project-local-settings#configure-in-your-personal-settings-initlua
            --         local path = client.workspace_folders[1].name

            --         -- print the settings to the log
            --         --vim.notify(vim.inspect(client.config.settings.ruff))
            --         --
            --         -- see lua pattern matching: https://www.lua.org/pil/20.2.html
            --         if string.find(path, "git/checkmk%-2%.1%.0") ~= nil then
            --             client.config.settings.ruff.lint.enable = false
            --         end

            --         client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
            --         return true
            --     end,
            -- })

            -- Check which capabilities a LSP has:
            -- :lua =vim.lsp.get_active_clients()[1].server_capabilities

            -- Enable this, then see :LspLog
            -- or `tail -f /home/lm/.local/state/nvim/lsp.log`
            -- :lua vim.lsp.set_log_level("debug")

            -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
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
                    --"python",
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
        -- https://github.com/stevearc/conform.nvim
        -- https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md
        -- See also :ConformInfo and ~/.local/state/nvim/conform.log
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        opts = {
            --log_level = vim.log.levels.DEBUG,
            formatters_by_ft = {
                python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
                lua = { "stylua" },
                sh = { "shfmt" },
                yaml = { "prettier" },
                --sql = { "sqlfluff" },
                --rust = { "rustfmt" },
                --go = { "gofumpt", "goimports", "gci" },
                --protobuf = { "buf" },
                dockerfile = { "hadolint" },
                --dockercompose = { "docker-compose" },
                bzl = { "buildifier" },
            },
            -- Set up format-on-save
            --format_on_save = { timeout_ms = 500, lsp_fallback = false },
            format_on_save = function(bufnr)
                -- Disable with a global or buffer-local variable
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                    return
                end
                return { timeout_ms = 500, lsp_fallback = false }
            end,
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

            lint.linters.shellcheck.args = {
                "--format",
                "json",
                "-x",
                "-",
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
