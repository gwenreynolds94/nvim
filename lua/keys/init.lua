---@class jk.keys
local K = {}

local kset = vim.keymap.set


--------------------------------------------------------------------------------


--- --[=====[
----- key utils {{{2

---@alias jk.keys.mode
---| 'n'
---| 'v'
---| 's'
---| 'x'
---| 'o'
---| '!'
---| 'i'
---| 'l'
---| 'c'
---| 't'

---@alias jk.keys.modes
---| jk.keys.mode[]

---@alias jk.keys.binder
---| fun(s:jk.keys.map): nil

---@type jk.keys.binder
function K.binder(s)
    local skeys = tb.keys(s)
    local has_leader = tb.contains(skeys, 'leader')
    local has_mode = tb.contains(skeys, 'mode')
    local has_opts = tb.contains(skeys, 'opts')
    ---- local has_lhspost = tb.contains(skeys, 'lhspost')
    ---@diagnostic disable: undefined-field
    local leader = (has_leader and s.leader) or [[]]
    local mode = (has_mode and s.mode) or { [[n]] }
    local opts = (has_opts and s.opts) or {}
    ---@diagnostic enable: undefined-field
    for lh, rh in pairs(s) do
        local reserved = (lh == 'leader') or (lh == 'mode') or
                         (lh == 'opts')   or (lh == 'bind')
        local altkey_id, alt_lh = lh:match[[^%<(%d+)%>(.+)$]]
        jk.last_id = altkey_id
        jk.last_lh = alt_lh
        if not reserved then
            if type(rh) == 'string' or type(rh) == 'function' then
                kset(mode, leader..(alt_lh and alt_lh or lh), rh, opts)
            elseif type(rh) == 'table' and tb.contains(tb.keys(getmetatable(rh) or {}), '__call') then
                kset(mode, leader..(alt_lh and alt_lh or lh), function() rh() end, opts)
            elseif type(rh) == 'table' then
                local rkeys = tb.keys(rh)
                local _has_index = #rh > 0
                local _has_rhs = tb.contains(rkeys, 'rhs')
                if not (_has_index or _has_rhs) then return end
                local _has_mode = tb.contains(rkeys, 'mode')
                local _has_opts = tb.contains(rkeys, 'opts')
                local _has_leader = tb.contains(rkeys, 'leader')
                local _rhs = (_has_rhs and rh.rhs) or rh[1]
                local _has_call = tb.contains(tb.keys(getmetatable(_rhs) or {}), '__call')
                kset((_has_mode and rh.mode) or mode,
                     (((_has_leader and rh.leader) or leader)..(alt_lh and alt_lh or lh)),
                     (_has_call and function() _rhs() end) or _rhs,
                     (_has_opts and rh.opts) or opts)
            end
        end
    end
end


function K:bindall()
    for _key, _val in pairs(self) do ---@cast _key string
        if _key:match[[keys$]]    and
            type(_val) == 'table' and
            tb.contains(tb.keys(_val), 'bind')
        then
            _val:bind()
        end
    end
end

K.nativeblacklist = {
    [=[^[cC]oc]=],
    [=[^[tT]elescope]=],
}

---@param _keyname string
---@return boolean
function K.nativeblacklist:matches(_keyname)
    for _, _blmatch in ipairs(self)
        do if _keyname:match(_blmatch) then return true end end
    return false
end

function K:bindnative()
    for _key, _val in pairs(self) do ---@cast _key string
        if not _key:match[[keys$]]                  then return end
        if not type(_val) == [[table]]              then return end
        if self.nativeblacklist:matches(_key)       then return end
        if not tb.contains(tb.keys(_val), [[bind]]) then return end
        _val:bind()
    end
end

----- key utils }}}2
--- --]=====]


--------------------------------------------------------------------------------


--- --[=====[
----- comment utils {{{2

K.comment = {}

K.comment.langs = {
    lua = { char = [[-]], thresh = 2, newlen = 3, suffix = [[ ]] },
    autohotkey = { char = [[;]], thresh = 1, newlen = 1, suffix = [[ ]] },
}

K.comment.line = {}

---@diagnostic disable-next-line
local function _comment_line(self)
    if (not vim.bo.modifiable) then return end
    local ft = vim.bo.filetype
    local ftc = K.comment.langs[ft]
    if not ftc then return false end
    --- ...
end
setmetatable(K.comment.line, { __call = _comment_line })

---@diagnostic disable-next-line
function K.comment.line:undo()
    ---
end



K.comment.range = {}

---@diagnostic disable-next-line
local function _comment_range(self)
    --- ...
end
setmetatable(K.comment.range, { __call = _comment_range })

---@diagnostic disable-next-line
function K.comment.range:undo()
    ---
end

----- comment utils }}}2
--- --]=====]


--------------------------------------------------------------------------------


--- --[=====[
----- window management {{{2

K.window = {}
K.window.width = {}
K.window.height = {}

function K.window.width.decrease()

end

function K.window.width.increase()

end

function K.window.height.decrease()

end

function K.window.height.increase()

end

function K.window.spelltoggle()
    vim.wo.spell = not vim.wo.spell
end

----- window management }}}2
--- --]=====]


--------------------------------------------------------------------------------


--- --[=====[
----- buffer management {{{2

K.buffers = {}

function K.buffers.show(_cmd_field)
    vim.cmd[[buffers]]
    if _cmd_field then vim.fn.feedkeys(_cmd_field) end
end

function K.buffers.select(_nolist, _buffer)
    local vcnt = vim.v.count
    local cmdstr = [[buf]] .. (_buffer and _buffer or ((vcnt ~= 0) and vcnt or [[]]))
    if not _nolist
    then K.buffers.show([[:]] .. cmdstr)
    else vim.cmd(cmdstr) end
end

function K.buffers.quik_select()
    local vcnt = vim.v.count
    K.buffers.select(true, ((vcnt ~= 0) and vcnt or [[]]))
end

---@param _nolist? `true`|`false` false by default
---@param _buffer? integer|nil
---@return nil
function K.buffers.delete(_nolist, _buffer)
    local vcnt = vim.v.count
    local cmdstr = [[bd]] .. (_buffer and _buffer or ((vcnt ~= 0) and vcnt or [[]]))
    if not _nolist
    then K.buffers.show([[:]] .. cmdstr)
    else vim.cmd(cmdstr) end
end

function K.buffers.quik_delete()
    local vcnt = vim.v.count
    K.buffers.delete(true, ((vcnt ~= 0) and vcnt or [[]]))
end

----- buffer management }}}2
--- --]=====]


--------------------------------------------------------------------------------


--- --[=====[
----- case conversion {{{2

K.case = {}

function K.case.camel_pascal_to_snake()
    local cword = vim.fn.expand'<cword>'
    local parsed_word = ''
    local first_iter = true
    for _word in cword:gmatch[=[[a-zA-Z][a-z]*]=] do
        if not first_iter then parsed_word = parsed_word..'_' end
        parsed_word = parsed_word .. _word:lower()
        first_iter = false
    end
    vim.fn.setreg('+', parsed_word)
    print(vim.inspect(parsed_word))
end

----- case conversion }}}2
--- --]=====]


--------------------------------------------------------------------------------


--- --[=====[
----- lua {{{2

K.lua = {}
K.lua.insert_header = {
    pattern = {
        top = {
            [[---- <fname>]]       ,
            [[local <retvar> = {}]],
            ([[-]]):rep(66)        ,
            [[]]                   ,
            [[]]                   ,
        },
        btm = {
            [[]]                   ,
            [[]]                   ,
            ([[-]]):rep(66)        ,
            [[return <retvar>]]    ,
            ([[-]]):rep(66)        ,
        }
    },
    replacements = {
        ['%<retvar%>'] = function() end,
        ['%<fname%>'] = function() end,
    }
}

K.utils = {}
K.utils.display_names = {
}
function K.utils.display_names.active()
    local fpath = vim.fn.expand[[%:p]]
    local fname = fpath:match[=[[/\]([^/\]+)$]=]
    if fname == 'init.lua' then
        fname = fpath:match([=[[/\]([^/\]+[/\][^/\]+)$]=]):gsub([=[[/\]]=], [[.]])
    end
end

---@diagnostic disable-next-line: unused-local
local function _lua_insert_header_ (_s)
    local fpath = vim.fn.expand[[%:p]]
    local fname = fpath:match[=[[/\]([^/\]+)$]=]
    if fname == 'init.lua' then
        fname = fpath:match([=[[/\]([^/\]+[/\][^/\]+)$]=]):gsub([=[[/\]]=], [[.]])
    end
    local is_lua = fname:match[[%.lua$]]
    if not is_lua then return end
    local repl_lines = {top={}, btm={}}
    for _loc, _tbl in pairs(K.lua.insert_header.pattern) do
        for _i, _ln in ipairs(_tbl) do
            _ln, _ = _ln:gsub([[%<fname%>]], fname)
            _ln, _ = _ln:gsub([[%<retvar%>]], fname:sub(0,1):upper())
            repl_lines[_loc][_i] = _ln
        end
    end
    vapi.nvim_buf_set_lines(0, 0, 0, false, repl_lines.top)
    vapi.nvim_buf_set_lines(0, -1, -1, false, repl_lines.btm)
end

setmetatable(K.lua.insert_header, { __call = _lua_insert_header_ })

----- lua }}}2
--- --]=====]


--------------------------------------------------------------------------------


--- --[=====[
----- autohotkey {{{2

K.ahk2 = {}
K.ahk2.exe_path = [["C:\Program Files\AutoHotkey\v2\AutoHotkey.exe"]]
K.ahk2.cmd_pre = K.ahk2.exe_path .. [[ /ErrorStdOut ]]
K.ahk2.exe_use_start = true
K.ahk2.warntype = 'OutputDebug'

---@param _warntype? string
function K.ahk2.insert_header(_warntype)
    _warntype = type(_warntype) == 'string' and _warntype or K.ahk2.warntype
    local fpath = vim.fn.expand[[%:p]]
    local fname = fpath:match[=[[/\]([^/\]+)$]=]
    local is_ahk = fname:match[[%.ahk$]]
    if not is_ahk then return end
    local header_lines = { [[; ]]..fname,
                           [[]],
                           [[#Requires AutoHotkey v2.0]],
                           [[#Warn All, StdOut]]        ,
                           [[#SingleInstance Force]]    ,
                           [[]] }
    vapi.nvim_buf_set_lines(0, 0, 0, false, header_lines)
end

function K.ahk2.run_current()
    local bufname = vapi.nvim_buf_get_name(0)
    local fpath = vim.fn.expand[[%:p]]
    if not bufname:match[[%.ahk$]] then
        vim.notify[[K.ahk2.run_current():::invalid_filetype]]
        return
    end
    vim.cmd([[!. ]]..fpath)
end

----- autohotkey }}}2
--- --]=====]


--------------------------------------------------------------------------------


--- --[=====[
----- coc management {{{2

K.coc = {}

function K.coc.cfg()
end

function K.coc.showhover()
    local cw = vim.fn.expand'<cword>'
    if vim.fn.index({'vim','help'}, vim.bo.filetype) >= 0 then
        vapi.nvim_command('h ' .. cw)
    elseif vapi.nvim_eval'coc#rpc#ready()' then
        vfn.CocActionAsync'doHover'
    else
        vapi.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end

if jk.isbs then
    vapi.nvim_create_augroup('CocGroup', {})
    vapi.nvim_create_autocmd('CursorHold', {
        group = 'CocGroup',
        command = [[silent call CocActionAsync('highlight')]],
        desc  = [[Highlight symbol under cursor on CursorHold]]
    })
end

----- coc management }}}2
--- --]=====]


--------------------------------------------------------------------------------


--- --[=====[
----- git {{{2

K.git = {}

function K.git.add_current_folder()
    vcmd[[!git add .]]
end

function K.git.status()
    vcmd[[!git status]]
end

function K.git.commit()
    local function onenter(_input)
        _input = _input or [[.]]
        vcmd([[!git commit -m "]] .. _input .. [["]])
    end
    vim.ui.input({
        prompt = [[Enter commit message... ]]
    }, onenter)
end

function K.git.push()
    vcmd[[!git push origin main]]
end

function K.git.addcommitpushall()
    K.git.add_current_folder()
    K.git.commit()
    K.git.push()
    K.git.status()
end

---@class jk.keys.map.git: jk.keys.map
K.git_keys = {
    bind = K.binder,
    leader = [[<leader>g]],
    ['a<leader>'] = K.git.add_current_folder,
    ['s<leader>'] = K.git.status,
    ['c<leader>'] = K.git.commit,
    ['p<leader>'] = K.git.push,
    ['acp<leader>'] = K.git.addcommitpushall,
}

----- git }}}2
--- --]=====]


--------------------------------------------------------------------------------


--------------------------------------------------------------------------------


--- --[=====[
----- testing {{{2

function K.test_meth()
----    --- local self = K
----    local nl = "\n"
----    local vcount, vcount1 = vim.v.count, vim.v.count1
----    local dbg = "<|empty|>"
----    ---@type string
----    local test_string = [[count:: ]] .. vcount1 .. [[(]] .. vcount .. [[)]] .. nl ..
----                        [[method:: (lua.keys.init).test_meth ]] .. nl ..
----                        [[debug:: ]] .. dbg
----    print(test_string)
----
    vim.cmd[[echo 'hello']]
end

----- testing }}}2
--- --]=====]


--------------------------------------------------------------------------------


--- --[=====[
----- key tables {{{2

---@class jk.keys.tblopts
---@field [`1`] string|function righthand mapping
---@field leader? string
---@field mode? jk.keys.modes
---@field opts? table

---@class jk.keys.map

---@class jk.keys.map.misc: jk.keys.map
K.misc_keys = {
    bind           = K.binder,
    [',,']         = [[@@]],
    ['<C-h>']      = [[<CMD>NvimTreeToggle<CR>]],
    ['<M-BS>']     = { [[<C-w>]], mode = { 'i', 'c' } },
    ['<M-Left>']   = { [[<C-\><C-n>]], mode = { 't' } },
    ['<M-/>']      = { [[<C-w><C-w>]], mode = { 'n', 'x' } },
    ['<M-?>']      = { [[<C-w><S-w>]], mode = { 'n', 'x' } },
    ['<M-S-t>']    = K.test_meth,
    ['<M-J>']      = [[<C-w>4-]],
    ['<C-M-j>']    = [[<C-w>16-]],
    ['<M-K>']      = [[<C-w>4+]],
    ['<C-M-k>']    = [[<C-w>16+]],
    ['<M-H>']      = [[<C-w>4<]],
    ['<C-M-h>']    = [[<C-w>16<]],
    ['<M-L>']      = [[<C-w>4>]],
    ['<C-M-l>']    = [[<C-w>16>]],
    ['<M-S-Down>'] = { [[<CMD>move+1<CR>]] , mode = { 'n', 'i', 'x', 'o' } } ,
    ['<M-S-Up>']   = { [[<CMD>move--1<CR>]], mode = { 'n', 'i', 'x', 'o' } } ,
    ['<C-M-Down>'] = { [[<CMD>copy+1<CR>]] , mode = { 'n', 'i', 'x', 'o' } } ,
    ['<C-M-Up>']   = { [[<CMD>copy-1<CR>]] , mode = { 'n', 'i', 'x', 'o' } } ,
    --- ['<C-x>']    = [[<Right>x<Left>]] ,
}

---@class jk.keys.map.insert_mode: jk.keys.map
K.insert_mode_keys = {
    bind = K.binder,
    mode = { 'i' },
    --- ['<C-x>'] = [[<C-[><Right><Right>x<Left>i]]
}

---@class jk.keys.map.input_mode: jk.keys.map
K.input_mode_keys = {
    bind      = K.binder,
    mode      = { 'i', 'c' },
    ['<M-/>'] = [[<C-[><C-w><C-w>]],
}

---@class jk.keys.map.term_mode: jk.keys.map
K.term_mode_keys = {
    bind      = K.binder,
    mode      = { 't' },
    ['<M-/>'] = [[<C-\><C-n><C-w><C-w>]],
}

---@class jk.keys.map.leader: jk.keys.map
K.leader_keys = {
    bind    = K.binder,
    leader  = [[<leader>]],
    ['<1>dd'] = [[yyp]],
    ['<1>dD'] = [[yyP]],
    ['<0>dd'] = { [[yP]], mode = { 'x' } },
    ['<0>dD'] = { [[yp]], mode = { 'x' } },
    rr      = [[<C-w>r]],
    RR      = [[<C-w>R]],
    noh     = [[<CMD>nohl<CR>]],
    undoall = [[<CMD>u0<CR>]],
    dnl     = [[<CMD>%s;\s\+$;<CR>]],
    sesh    = [[<CMD>SessionManager load_session<CR>:bd]],
    spv     = [[<CMD>vsplit<CR>]],
    spl     = [[<CMD>split<CR>]],
    ssp     = [[<CMD>SessionManager load_last_session<CR>]],
    ssg     = [[<CMD>SessionManager load_session<CR>]],
    cword   = K.case.camel_pascal_to_snake,
    regx    = [[<CMD>call setreg('+', getreg('x'))<CR>]],
    tf      = [[<CMD>s;true;false<CR><CMD>nohl<CR>]],
    ft      = [[<CMD>s;false;true<CR><CMD>nohl<CR>]],
    ['re<space>'] = [[<CMD>registers<CR>]],
    ['<0>/']      = [[<C-[>:s/\v]],
    ['<2>/']      = { [[<C-[>:%s/\v]], leader = [[<leader><leader>]] },
    ['<1>/']      = { [[:s/\v]],  mode = { 'x' } },
    ['<3>/']      = { [[:%s/\v]], mode = { 'x' }, leader = [[<leader><leader>]] },
    ---|    ahkhead = K.ahk2.insert_header,
---|    ahkrun  = K.ahk2.run_current,
}

---@class jk.keys.map.ahk2_leader: jk.keys.map
K.ahk2_leader_keys = {
    bind   = K.binder,
    leader = [[<leader>ah]],
    ed     = K.ahk2.insert_header,
    r      = K.ahk2.run_current,
    cm     = { [[<CMD>s/^/; /<CR><CMD>nohl<CR>]], mode = { 'n', 'x' } },
    uc     = { [==[<CMD>s/\v(^\s+)@<=(;+\s*)+//<CR><CMD>nohl<CR>]==], mode = { 'n', 'x' } }
}

---@class jk.keys.map.lua_leader: jk.keys.map
K.lua_leader_keys = {
    bind   = K.binder,
    leader = [[<leader>l]],
    hed    = K.lua.insert_header,
}

---@class jk.keys.map.win_leader: jk.keys.map
K.win_leader_keys = {
    bind             = K.binder           ,
    leader           =   [[<leader>w]]    ,
    ['<space>']      =   [[<CMD>w<CR>]]   ,
    ['w<space>']     =   [[<CMD>w!<CR>]]  ,
    ['<0>q<space>']  =   [[<CMD>wq<CR>]]  ,
    ['<0>qq<space>'] =   [[<CMD>wq!<CR>]] ,
    ['<0>qa<space>'] =   [[<CMD>wqa<CR>]] ,
    ['<1>q<space>']  = { [[<CMD>q<CR>]]   , leader = [[<leader>]] } ,
    ['<1>qq<space>'] = { [[<CMD>q!<CR>]]  , leader = [[<leader>]] } ,
    ['qaa<space>']   = { [[<CMD>qa!<CR>]] , leader = [[<leader>]] } ,
    ['<1>qa<space>'] = { [[<CMD>qa<CR>]]  , leader = [[<leader>]] } ,
    ['<PageDown>']   =   [[<C-w>J]]       ,
    ['<PageUp>']     =   [[<C-w>K]]       ,
    ['<Home>']       =   [[<C-w>H]]       ,
    ['<End>']        =   [[<C-w>L]]       ,
    s                =   [[<C-w>|]]       ,
    t                =   [[<C-w>_]]       ,
    e                =   [[<C-w>=]]       ,
    sp = K.window.spelltoggle,
}

---@class jk.keys.map.buf_leader: jk.keys.map
K.buf_leader_keys = {
    bind   = K.binder,
    leader = [[<leader>b]],
    b      = [[<CMD>bp<CR>]],
    v      = [[<CMD>bn<CR>]],
    d      = K.buffers.delete,
    D      = K.buffers.quik_delete,
    g      = K.buffers.select,
    G      = K.buffers.quik_select,
    f      = [[<CMD>buffers<CR>]],
}

---@class jk.keys.map.coc_leader: jk.keys.map
K.coc_leader_keys = {
    bind           =   K.binder,
    leader         =   [[<leader>c]],
    diag           =   [[<CMD>CocDiagnostics<CR>]],
    ol             =   [[<CMD>CocOutline<CR>]],
    doc            =   K.coc.showhover,
    ['<C-M-a>']    = { K.coc.showhover, leader = [[]] },
    ['rn<leader>'] = { [[<CMD>CocCommand document.renameCurrentWord<CR>]], leader=[[<leader>]], opts={remap=true} },
    rnn            = { [[<Plug>(coc-rename)]], leader=[[<leader>]], opts={remap=true} },
    out            =   [[<CMD>CocCommand workspace.showOutput<CR>]],
    spa            =   [[<CMD>CocCommand cSpell.addWordToWorkspaceDictionary<CR>]],
    ['s<leader>']  = { [[<CMD>CocCommand cSpell.addWordToWorkspaceDictionary<CR>]], leader = [[<leader>]] },
    ['si<leader>'] = { [[<CMD>CocCommand cSpell.addIgnoreWord<CR>]], leader = [[<leader>]] },
    ['fgl<leader>'] =  [[<CMD>CocLocalConfig<CR>]],
    ['fg<leader>'] =   [[<CMD>CocConfig<CR>]],
}

---@class jk.keys.map.coc_select: jk.keys.map
K.coc_select_keys = {
    bind = K.binder,
    mode = { 'x', 'o' },
    ['if']   =   [[<Plug>(coc-funcobj-i)]]      ,
    af       =   [[<Plug>(coc-funcobj-a)]]      ,
    ic       =   [[<Plug>(coc-classobj-i)]]     ,
    ac       =   [[<Plug>(coc-classobj-a)]]     ,
    fs       = { [[<Plug>(coc-format-selected)]], leader = [[<leader>]] }
}

---@class jk.keys.map.telescope: jk.keys.map
K.telescope_keys = {
    bind = K.binder,
    leader = [[<leader>t]],
    he = [[<CMD>Telescope help_tags<CR>]],
}


----- key tables }}}2
--- --]=====]


--------------------------------------------------------------------------------


--- --[=====[
----- coc bindings {{{2

local tab_opts = {
    silent = true,
    noremap = true,
    expr = true,
    replace_keycodes = false
}

function _G._jk_check_backspace()
    local col = vim.fn.col[[.]] - 1
    return col == 0 or vim.fn.getline[[.]]:sub(col, col):match[[%s]] ~= nil
end

kset( [[i]], [[<TAB>]],
    [[coc#pum#visible() ? coc#pum#next(1) : v:lua._jk_check_backspace() ? "<TAB>" : coc#refresh()]],
    tab_opts)
kset( [[i]], [[<S-TAB>]],
    [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]],
    tab_opts)

----- coc bindings }}}2
--- --]=====]


--------------------------------------------------------------------------------


return K
