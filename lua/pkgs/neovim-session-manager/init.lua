local S = {}

--- local Path = require'plenary.path'
local config = require'session_manager.config'

require'session_manager'.setup{
    --- sessions_dir = Path:new(vim.fn.stdpath'data', 'sessions'),
    autoload_mode = config.AutoloadMode.CurrentDir,
    autosave_ignore_dirs = {
        [[C:/Users/jonat]],
        [[C:/Users/jonat/Documents]],
        [[C:/Users/jonat/Portables]],
        [[C:/Users/jonat/AppData]],
        [[C:/Users/jonat/.config]],
        [[C:/Users/jonat/.local/share]],
        [[C:/Users/jonat/.local/share/nvim-data]]
    }
}

return S
