return {
    cmd = { vim.fn.stdpath("data") .. "/mason/bin/yaml-language-server", "--stdio" },
    filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
    root_markers = { ".git" },
    settings = {
        yaml = {
            validate = true,
            format = { enable = false },
            schemaStore = {
                enable = false, -- disable built-in schemaStore to use schemastore.nvim
                url = "",
            },
            schemas = require("schemastore").yaml.schemas(),
        },
    },
}
