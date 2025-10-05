-- helpful docs:
-- https://github.com/hrsh7th/nvim-cmp
-- https://github.com/hrsh7th/nvim-cmp/wiki/Advanced-techniques#managing-completion-timing-completely
return {
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-emoji",
            opts = nil,
        },
        opts = function(_, opts)
            opts.performance = {
                -- debounce = 300,
                -- Give AI's a bit more time
                fetching_timeout = 2000,
            }
            opts.experimental = {
                ghost_text = true,
            }

            opts.snippet = {
                -- REQUIRED - you must specify a snippet engine
                expand = function(args)
                    vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                    -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                    -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                    -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                end,
            }

            opts.window = {
                -- completion = cmp.config.window.bordered(),
                -- documentation = cmp.config.window.bordered(),
            }

            local cmp = require("cmp")
            local lspkind = require("lspkind")

            -- If you want insert `(` after select function or method item
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

            -- Hide suggestion automatically when completion menu is open
            local suggestion = require("copilot.suggestion")
            cmp.event:on("menu_opened", function()
                if suggestion.is_visible() then
                    suggestion.dismiss()
                end
                vim.b.copilot_suggestion_hidden = true
            end)
            cmp.event:on("menu_closed", function()
                vim.b.copilot_suggestion_hidden = false
                suggestion.next()
            end)

            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            local feedkey = function(key, mode)
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
            end

            opts.mapping = {
                ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i" }),
                ["<Down>"] = cmp.mapping(
                    cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                    { "i" }
                ),
                ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),
                ["<C-n>"] = cmp.mapping({
                    i = function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                        else
                            fallback()
                        end
                    end,
                }),
                ["<C-p>"] = cmp.mapping({
                    i = function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                        else
                            fallback()
                        end
                    end,
                }),
                ["<CR>"] = cmp.mapping({
                    i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
                    c = function(fallback)
                        if cmp.visible() then
                            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                        else
                            fallback()
                        end
                    end,
                }),
                ["<C-y>"] = cmp.mapping({
                    i = cmp.mapping.confirm({ select = false }),
                }),
                ["<C-e>"] = cmp.mapping({
                    i = cmp.mapping.abort(),
                }),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        --cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
                        -- Confirm with tab, and if no entry is selected, will confirm the first item
                        local entry = cmp.get_selected_entry()
                        if not entry then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                        end
                        cmp.confirm()
                    elseif require("copilot.suggestion").is_visible() then
                        require("copilot.suggestion").accept()
                    elseif vim.fn["vsnip#available"](1) == 1 then
                        feedkey("<Plug>(vsnip-expand-or-jump)", "")
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
                    end
                end, { "i", "s" }),
            }

            opts.sources = cmp.config.sources({
                { name = "copilot", group_index = 1000 },
                {
                    -- search all buffers
                    -- Maybe try https://github.com/tzachar/cmp-fuzzy-buffer
                    name = "buffer",
                    option = {
                        get_bufnrs = function()
                            return vim.api.nvim_list_bufs()
                        end,
                    },
                    entry_filter = function(entry)
                        return not entry.exact
                    end,
                    priority = 900,
                    max_item_count = 5,
                },
                { name = "nvim_lsp", priority = 800 },
                { name = "nvim_lsp_signature_help", priority = 700 },
                --{ name = "vsnip", priority = 600 },
                { name = "path" },
            })

            opts.formatting = {
                format = lspkind.cmp_format({
                    mode = "symbol", -- show only symbol annotations
                    maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                    show_labelDetails = true,
                    ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                    symbol_map = { Copilot = "" },

                    -- The function below will be called before any actual modifications from lspkind
                    -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
                    -- before = function (entry, vim_item)
                    --   -- ...
                    --   return vim_item
                    -- end
                }),
            }

            -- Set configuration for specific filetype.
            cmp.setup.filetype("gitcommit", {
                sources = cmp.config.sources({
                    { name = "git" }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
                }, {
                    { name = "buffer" },
                }),
            })
        end,
    },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "dmitmel/cmp-cmdline-history" },
    { "hrsh7th/vim-vsnip" },
    { "hrsh7th/vim-vsnip-integ" },
    { "onsails/lspkind.nvim" },
}
