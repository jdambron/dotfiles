require'nvim-treesitter.configs'.setup {
    ensure_installed = { "css", "html", "javascript", "lua", "rust", "toml", "typescript" }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    highlight = {
        enable = true,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
        },
    },
    indent = {
        enable = true
    },
    context_commentstring = {
        enable = true
    },
}
