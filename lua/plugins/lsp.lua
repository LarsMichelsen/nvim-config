--local on_attach_navic = function(client, bufnr)
--    if client.server_capabilities.documentSymbolProvider then
--        require("nvim-navic").attach(client, bufnr)
--    end
--end

return {
    {
        "mason-org/mason.nvim",
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
    {
        "ray-x/lsp_signature.nvim",
        event = "InsertEnter",
        opts = {
            --debug = true,
            --log_path = vim.fn.stdpath("log") .. "/lsp_signature.log",
            bind = true,
            handler_opts = {
                border = "single",
            },
            fix_pos = true, -- do not change position until finished
            hint_enable = false, -- disable virtual hint
            max_width = 80,
        },
    },
}
