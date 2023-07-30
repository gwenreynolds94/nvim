

require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = false,
        globalstatus = true,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        }
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'progress', 'location', 'g:coc_status', 'b:coc_current_function'},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {'b:coc_git_status', 'b:coc_git_blame'},
        lualine_z = {'encoding', 'fileformat', 'filetype'}
    },
    inactive_sections = {},
    tabline = {
        lualine_a = {'branch'},
        lualine_b = {'buffers'},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {'tabs'},
        lualine_z = {'location','progress'}
    },
    winbar = {},
    inactive_winbar = {},
    extensions = {}
}
