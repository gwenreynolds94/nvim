local I = {}

vim.opt.list = true
vim.opt.listchars:append "space:⋅"
--- vim.opt.listchars:append "eol:↴"

I.highlight = {
    'RainbowRed',
    'RainbowYellow',
    'RainbowBlue',
    'RainbowOrange',
    'RainbowGreen',
    'RainbowViolet',
    'RainbowCyan',
}


--[===[
I.hooks = require'ibl.hooks'
I.hooks.register(I.hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)
--]===]

require'ibl'.setup {
    --- indent = { highlight = I.highlight }
}

---require("indent_blankline").setup()
---{
    --- show_end_of_line = true,
---    space_char_blankline = " ",
---}

return I
