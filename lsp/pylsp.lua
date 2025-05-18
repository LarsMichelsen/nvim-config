---
--- A Python 3.6+ implementation of the Language Server Protocol.
---
--- See the [project's README](https://github.com/python-lsp/python-lsp-server) for installation instructions.
---
--- Configuration options are documented [here](https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md).
--- In order to configure an option, it must be translated to a nested Lua table and included in the `settings` argument to the `config('pylsp', {})` function.
--- For example, in order to set the `pylsp.plugins.pycodestyle.ignore` option:
--- ```lua
--- vim.lsp.config('pylsp', {
---   settings = {
---     pylsp = {
---       plugins = {
---         pycodestyle = {
---           ignore = {'W391'},
---           maxLineLength = 100
---         }
---       }
---     }
---   }
--- })
--- ```
---
--- Note: This is a community fork of `pyls`.
return {
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
