return {
    cmd = {
        "bazel",
        "run",
        "//packages/cmk-astrein:astrein-lsp",
        "--",
        "--repo-root",
        "/home/lm/git/checkmk",
    },
    filetypes = { "python" },
    -- Only start in repos that actually ship the astrein Bazel target
    -- (i.e. the checkmk repo); other repos are not Bazel workspaces and
    -- `bazel run` would fail there.
    root_dir = function(bufnr, on_dir)
        local root = vim.fs.root(bufnr, "MODULE.bazel")
        if root and vim.uv.fs_stat(root .. "/packages/cmk-astrein/BUILD") then
            on_dir(root)
        end
    end,
}
