return {
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    build = function()
        vim.fn["mkdp#util#install"]()
    end,
    init = function()
        vim.g.mkdp_echo_preview_url = 1
        vim.g.mkdp_port = '12121'
        vim.g.mkdp_browser = 'firefox'
        -- vim.cmd([[
        -- let $NVIM_MKDP_LOG_FILE = expand('~/mkdp-log.log')
        -- let $NVIM_MKDP_LOG_LEVEL = 'debug'
        -- ]])

        --
        -- Markdown syntax
        --
        
        vim.g.vim_markdown_folding_disabled = 1
        vim.g.vim_markdown_conceal = 0
        vim.g.tex_conceal = ""
        vim.g.vim_markdown_math = 1
        vim.g.vim_markdown_frontmatter = 1
        vim.g.vim_markdown_toml_frontmatter = 1
        vim.g.vim_markdown_json_frontmatter = 1
    end,
  },
}

