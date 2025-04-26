return {
    {
        "saghen/blink.cmp",
        -- optional: provides snippets for the snippet source
        dependencies = {
            "rafamadriz/friendly-snippets",
            "ribru17/blink-cmp-spell",
            "fang2hou/blink-copilot",
            --"giuxtaposition/blink-cmp-copilot",
        },
        version = "v1.*",
        -- AND/OR build from source
        --build = 'cargo +nightly build --release'

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
            -- 'super-tab' for mappings similar to vscode (tab to accept)
            -- 'enter' for enter to accept
            -- 'none' for no mappings
            --
            -- All presets have the following mappings:
            -- C-space: Open menu or open docs if already open
            -- C-n/C-p or Up/Down: Select next/previous item
            -- C-e: Hide menu
            -- C-k: Toggle signature help (if signature.enabled = true)
            --
            -- See :h blink-cmp-config-keymap for defining your own keymap
            keymap = { preset = "enter" },

            appearance = {
                -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = "mono",
            },

            completion = {
                -- Recommended to avoid unnecessary request
                trigger = { prefetch_on_insert = false },

                -- Don't select by default, auto insert on selection
                list = { selection = { preselect = false, auto_insert = false } },

                menu = {
                    -- Don't automatically show the completion menu
                    auto_show = true,

                    -- nvim-cmp style menu
                    draw = {
                        columns = {
                            { "label", "label_description", gap = 1 },
                            { "kind_icon", "kind" },
                        },
                    },
                },

                -- (Default) Only show the documentation popup when manually triggered
                documentation = { auto_show = false },

                -- Show documentation when selecting a completion item
                documentation = { auto_show = true, auto_show_delay_ms = 500 },
                -- Display a preview of the selected item on the current line
                ghost_text = { enabled = true },
            },

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
                default = { "copilot", "lsp", "path", "snippets", "buffer" },
                providers = {
                    copilot = {
                        name = "copilot",
                        module = "blink-copilot",
                        --module = "blink-cmp-copilot",
                        score_offset = 100,
                        async = true,
                    },
                    spell = {
                        name = "Spell",
                        module = "blink-cmp-spell",
                        opts = {
                            -- EXAMPLE: Only enable source in `@spell` captures, and disable it
                            -- in `@nospell` captures.
                            enable_in_context = function()
                                local curpos = vim.api.nvim_win_get_cursor(0)
                                local captures = vim.treesitter.get_captures_at_pos(0, curpos[1] - 1, curpos[2] - 1)
                                local in_spell_capture = false
                                for _, cap in ipairs(captures) do
                                    if cap.capture == "spell" then
                                        in_spell_capture = true
                                    elseif cap.capture == "nospell" then
                                        return false
                                    end
                                end
                                return in_spell_capture
                            end,
                        },
                    },
                },
            },

            -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
            -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
            -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
            --
            -- See the fuzzy documentation for more information
            fuzzy = {
                implementation = "prefer_rust_with_warning",
                sorts = {
                    function(a, b)
                        local sort = require("blink.cmp.fuzzy.sort")
                        if a.source_id == "spell" and b.source_id == "spell" then
                            return sort.label(a, b)
                        end
                    end,
                    -- This is the normal default order, which we fall back to
                    "score",
                    "kind",
                    "label",
                },
            },

            -- Experimental signature help support
            signature = { enabled = true },

            cmdline = {
                enabled = false,
            },
        },
        opts_extend = { "sources.default" },
    },
}
