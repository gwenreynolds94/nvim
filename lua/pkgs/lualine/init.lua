

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
        globalstatus = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        }
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {
            [[progress]],
            [[location]],
            [[b:coc_current_function]],
            [[g:coc_status]],
        },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {'b:coc_git_status', 'b:coc_git_blame'},
        lualine_z = {'encoding', 'fileformat', function() return vim.o.shell end, 'filetype'}
    },
    inactive_sections = {},
    tabline = {
        lualine_a = {'branch'},
        lualine_b = {{
            'buffers',
            mode = 4,
            max_length = function()
                local len = vim.o.columns - 30
                return (len > 30) and len or (vim.o.columns * 4 / 3)
            end,
        }},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {'tabs'},
        lualine_z = {'location','progress'}
    },
    winbar = {},
    inactive_winbar = {},
    extensions = {}
}
