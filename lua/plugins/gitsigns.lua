--- Wrapper for tree-sitter repeatable move,
--- avoid error when the module is not loaded
---@param forward_move_fn function
---@param backward_move_fn function
function make_repeatable_move_pair(forward_move_fn, backward_move_fn)
    local function move_fn(opts)
        if opts.forward then
            return forward_move_fn()
        else
            return backward_move_fn()
        end
    end

    local loaded_ts, ts_repeatable
    return function()
        if not loaded_ts then
            loaded_ts, ts_repeatable = pcall(require, "nvim-treesitter-textobjects.repeatable_move")
            if loaded_ts then
                move_fn = ts_repeatable.make_repeatable_move(move_fn)
            end
        end
        return move_fn({ forward = true })
    end, function()
        if not loaded_ts then
            loaded_ts, ts_repeatable = pcall(require, "nvim-treesitter-textobjects.repeatable_move")
            if loaded_ts then
                move_fn = ts_repeatable.make_repeatable_move(move_fn)
            end
        end
        return move_fn({ forward = false })
    end
end

--- Turn the first letter of a string to uppercase
---@param str string
---@return string uppercased
function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

---@type LazyPluginSpec
return {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    dependencies = "nvim-lua/plenary.nvim",
    keys = {
        -- {
        --     "<leader>gt",
        --     function()
        --         require("gitsigns").blame()
        --     end,
        --     desc = "Blame",
        -- },
    },
    opts = {
        word_diff = false,
        attach_to_untracked = true,
        on_attach = function(bufnr)
            local gitsigns = require("gitsigns")
            local next_hunk, prev_hunk = make_repeatable_move_pair(function()
                gitsigns.nav_hunk("next")
            end, function()
                gitsigns.nav_hunk("prev")
            end)

            -- Navigation
            vim.keymap.set("n", "]h", function()
                if vim.wo.diff then
                    vim.cmd.normal({ "]h", bang = true })
                else
                    next_hunk()
                end
            end, { buffer = bufnr, desc = "Next hunk" })

            vim.keymap.set("n", "[h", function()
                if vim.wo.diff then
                    vim.cmd.normal({ "[h", bang = true })
                else
                    prev_hunk()
                end
            end, { buffer = bufnr, desc = "Previous hunk" })

            -- Actions
            vim.keymap.set("n", "<leader>gs", gitsigns.stage_hunk, { buffer = bufnr, desc = "Stage hunk" })
            vim.keymap.set("v", "<leader>gs", function()
                gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, { buffer = bufnr, desc = "Stage hunk" })
            vim.keymap.set("n", "<leader>gr", gitsigns.reset_hunk, { buffer = bufnr, desc = "Reset hunk" })
            vim.keymap.set("v", "<leader>gr", function()
                gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, { buffer = bufnr, desc = "Reset hunk" })
            vim.keymap.set("n", "<leader>gu", gitsigns.undo_stage_hunk, { buffer = bufnr, desc = "Undo stage hunk" })
            vim.keymap.set("n", "<leader>gS", gitsigns.stage_buffer, { buffer = bufnr, desc = "Stage buffer" })
            vim.keymap.set("n", "<leader>gR", gitsigns.reset_buffer, { buffer = bufnr, desc = "Reset buffer" })
            vim.keymap.set("n", "<leader>gp", gitsigns.preview_hunk, { buffer = bufnr, desc = "Preview hunk" })
            -- vim.keymap.set("n", "<leader>gb", function()
            --     gitsigns.blame_line({ full = true })
            -- end, { buffer = bufnr, desc = "Blame line" })

            vim.keymap.set("n", "<leader>td", gitsigns.toggle_deleted, { buffer = bufnr, desc = "Deleted" })
            vim.keymap.set(
                "n",
                "<leader>tb",
                gitsigns.toggle_current_line_blame,
                { buffer = bufnr, desc = "Line Blame" }
            )

            -- Text object
            vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "a git hunk" })
            vim.keymap.set({ "o", "x" }, "ah", ":<C-U>Gitsigns select_hunk<CR>", { desc = "a git hunk" })
        end,
    },
    config = function(_, opts)
        require("gitsigns").setup(opts)

        local function set_hl()
            vim.api.nvim_set_hl(0, "GitSignsChangeLn", { link = "DiffText" })
            vim.api.nvim_set_hl(0, "GitSignsDeleteLn", { link = "DiffDelete" })

            vim.api.nvim_set_hl(0, "GitSignsAddInline", { link = "GitSignsAddLn" })
            vim.api.nvim_set_hl(0, "GitSignsDeleteInline", { link = "GitSignsDeleteLn" })
            vim.api.nvim_set_hl(0, "GitSignsChangeInline", { link = "GitSignsChangeLn" })
        end
        set_hl()
        vim.api.nvim_create_autocmd("ColorScheme", {
            desc = "Set gitsigns highlights",
            callback = set_hl,
        })
    end,
}
