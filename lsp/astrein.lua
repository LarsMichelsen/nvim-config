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
    root_markers = {
        ".git",
        "pyproject.toml",
    },
}
