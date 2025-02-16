return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-neotest/neotest-python",
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-python")({

                        -- Extra arguments for nvim-dap configuration
                        -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
                        dap = { justMyCode = false },
                        -- Here you can specify the settings for the adapter, i.e.
                        --runner = "pytest",
                        --python = ".venv/bin/python",
                        -- Only care for files in tests/unit
                        is_test_file = function(file_path)
                            if not vim.endswith(file_path, ".py") then
                                return false
                            end
                            if not string.find(file_path, "tests/unit") then
                                return false
                            end
                            local elems = vim.split(file_path, "/")
                            local file_name = elems[#elems]
                            return vim.startswith(file_name, "test_")
                        end,
                    }),
                },
            })
        end,
    },
}
