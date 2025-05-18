---@brief
---
--- https://github.com/pappasam/jedi-language-server
---
--- `jedi-language-server`, a language server for Python, built on top of jedi
return {
    cmd = {
        vim.fn.stdpath("data") .. "/mason/bin/jedi-language-server",
        -- "/home/lm/.local/share/nvim/mason/bin/jedi-language-server"
        -- For debugging
        --"-v",
        --"--log-file",
        --"/home/lm/.local/state/nvim/jedi.log",
    },
    filetypes = { "python" },
    root_markers = {
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        "Pipfile",
        ".git",
    },
}
