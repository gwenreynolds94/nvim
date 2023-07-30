require'nvim-tree'.setup {
    sort_by = 'case_sensitive',
    git = {
        timeout = 666
    },
    view = { width = 30 },
    renderer = { group_empty = true },
    filters = { dotfiles = false },
    modified = { enable = true },
}

