
function _G.symbol_line()
  local curwin = vim.g.statusline_winid or 0
  local curbuf = vim.api.nvim_win_get_buf(curwin)
  local ok, line = pcall(vim.api.nvim_buf_get_var, curbuf, 'coc_symbol_line')
  return ok and line or ''
end

---| vim.o.tabline = '%!v:lua.symbol_line()'
---| vim.o.statusline = '%!v:lua.symbol_line()'
---| vim.o.winbar = '%!v:lua.symbol_line()'

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
            statusline = 666,
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
            --- [[g:coc_status]],
        },
        lualine_c = {},
        lualine_x = {},
        lualine_y = { _G.symbol_line },
        lualine_z = {'encoding', 'filetype'}, ---[function() return vim.o.shell end 'fileformat'}
        ---| lualine_z = { 'b:coc_git_status', 'b:coc_git_blame' },
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
