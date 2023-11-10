---- autopairs.init.lua
local A = {}
------------------------------------------------------------------

A.npairs = require'nvim-autopairs'
A.Rule = require'nvim-autopairs.rule'

A.npairs.setup{
    disable_in_macro = true,
    enable_check_bracket_line = true,
    check_ts = true,
    fastwrap = {},
}

A.tsconds = require'nvim-autopairs.ts-conds'

--- A.npairs.add_rules{ A.Rule("(", "", "autohotkey"):with_pair(A.tsconds.is_not_ts_node{ 'string', 'comment' }) }
------------------------------------------------------------------
return A
------------------------------------------------------------------
