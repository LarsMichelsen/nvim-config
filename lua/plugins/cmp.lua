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

            local cmp = require('cmp')
            local lspkind = require('lspkind')

            local has_words_before = function()
              unpack = unpack or table.unpack
              local line, col = unpack(vim.api.nvim_win_get_cursor(0))
              return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            local feedkey = function(key, mode)
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
            end

            opts.mapping = cmp.mapping.preset.insert({
              -- See also: https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings
              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<C-e>'] = cmp.mapping.abort(),
              ['<CR>'] = cmp.mapping({
                  -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                  i = cmp.mapping.confirm({ select = false }),
                  s = cmp.mapping.confirm({ select = false })
                  -- c = function(fallback)
                  --     if cmp.visible() and cmp.get_active_entry() then
                  --        cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                  --        cmp.complete()
                  --      else
                  --        fallback()
                  --      end
                  -- end
              }),

              ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  -- cmp.select_next_item()
                  cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
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

              ["<S-Tab>"] = cmp.mapping(function()
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                  feedkey("<Plug>(vsnip-jump-prev)", "")
                else
                  fallback()
                end
              end, { "i", "s" }),
            })

            opts.sources = cmp.config.sources({
              { name = 'nvim_lsp', priority = 1000 },
              { name = "copilot", group_index = 900 },
              { name = 'vsnip', priority = 800 },
              {
                -- search all buffers
                -- Maybe try https://github.com/tzachar/cmp-fuzzy-buffer
                name = 'buffer',
                option = {
                  get_bufnrs = function()
                    return vim.api.nvim_list_bufs()
                  end
                }
              }
            })

            opts.formatting = {
              format = lspkind.cmp_format({
                mode = 'symbol', -- show only symbol annotations
                maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                -- symbol_map = { Codeium = "", },
                symbol_map = { Copilot = "" }

                -- The function below will be called before any actual modifications from lspkind
                -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
                -- before = function (entry, vim_item)
                --   -- ...
                --   return vim_item
                -- end
              })
            }

            -- Set configuration for specific filetype.
            cmp.setup.filetype('gitcommit', {
              sources = cmp.config.sources({
                { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
              }, {
                { name = 'buffer' },
              })
            })

            -- -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
            -- cmp.setup.cmdline({ '/', '?' }, {
            --   mapping = cmp.mapping.preset.cmdline(),
            --   sources = {
            --     { name = 'buffer' }
            --   }
            -- })
            -- 
            -- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            -- cmp.setup.cmdline(':', {
            --   -- mapping = cmp.mapping.preset.cmdline(),
            --   sources = {
            --     { name = 'cmdline' }
            --   }
            --   -- cmp.config.sources(
            --   -- --{
            --   -- --  { name = 'cmdline_history' }
            --   -- --}
            --   -- {
            --   --   { name = 'path' }
            --   -- }
            --   -- -- {
            --   -- --   { name = 'cmdline' }
            --   -- -- }
            --   -- ),
            -- })

        end,
    },
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/cmp-buffer'},
    {'hrsh7th/cmp-path'},
    {'hrsh7th/cmp-cmdline'},
    {'dmitmel/cmp-cmdline-history'},
    {'hrsh7th/vim-vsnip'},
    {'hrsh7th/vim-vsnip-integ'},
    {'onsails/lspkind.nvim'},
}
