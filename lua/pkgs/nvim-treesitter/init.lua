--- nvim.lua.pkgs.nvim-treesitter.init.lua

local T = {}

T.install_lib = require'nvim-treesitter.install'
T.install_lib.compilers = { "gcc", "clang" }

T.custom_captures = {
    ['variable.builtin.vim.lua'] = "Identifier"
}
T.configs_lib = require'nvim-treesitter.configs'
function T:setup()
    self.configs_lib.setup{
        highlight = {
            enable = true,
            custom_captures = self.custom_captures,
            additional_vim_regex_highlighting = false,
        }
    }
    self:hlset()
end

function T:minimal()
    self.configs_lib.setup{highlight={enable=true}} end

function T:hlset()
    for _groupname, _grouplink in pairs(self.custom_captures) do
        vapi.nvim_set_hl(0, "@" .. _groupname, { link = _grouplink })
    end
end

if jk.conf.tsminimal
then T:minimal()
else T:setup() end

return T
