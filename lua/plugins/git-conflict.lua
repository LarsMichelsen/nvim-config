return {}
-- return {
--     "akinsho/git-conflict.nvim",
--     version = "*",
--     config = true,
--     default_mappings = false,
--     opts = {
--         on_attach = function(bufnr)
--             vim.keymap.set("n", "co", "<Plug>(git-conflict-ours)", { buffer = bufnr, desc = "Choose ours" })
--             vim.keymap.set("n", "ct", "<Plug>(git-conflict-theirs)", { buffer = bufnr, desc = "Choose theirs" })
--             vim.keymap.set("n", "cb", "<Plug>(git-conflict-both)", { buffer = bufnr, desc = "Choose both" })
--             vim.keymap.set("n", "c0", "<Plug>(git-conflict-none)", { buffer = bufnr, desc = "Choose none" })
--             vim.keymap.set(
--                 "n",
--                 "[x",
--                 "<Plug>(git-conflict-prev-conflict)",
--                 { buffer = bufnr, desc = "Previous conflict" }
--             )
--             vim.keymap.set("n", "]x", "<Plug>(git-conflict-next-conflict)", { buffer = bufnr, desc = "Next conflict" })
--         end,
--     },
-- }
