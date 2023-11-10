local JK = {}

_G.jk = {
    dbg = {},
    dynamic_opts = {},
    ftplugin = {},
    conf = {
        ahk = {
            header = {
                req = true,
                warn = false,
                single = false,
            },
        },
    },
}

_G.tb = {
    foreach = table.foreach,
    foreachi = table.foreachi,
    concat = table.concat,
    insert = table.insert,
    remove = table.remove,
    getn = table.getn,
    maxn = table.maxn,
    move = table.move,
    sort = table.sort,
    get = vim.tbl_get,
    map = vim.tbl_map,
    keys = vim.tbl_keys,
    count = vim.tbl_count,
    values = vim.tbl_values,
    filter = vim.tbl_filter,
    islist = vim.tbl_islist,
    extend = vim.tbl_extend,
    isempty = vim.tbl_isempty,
    flatten = vim.tbl_flatten,
    contains = vim.tbl_contains,
    list_slice = vim.list_slice,
    list_extend = vim.list_extend,
    deep_extend = vim.tbl_deep_extend,
    list_contains = vim.list_contains,
    add_reverse_lookup = vim.tbl_add_reverse_lookup,
    index = vim.fn.index,
}

_G.vapi = vim.api
_G.vfn  = vim.fn
_G.vcmd = vim.cmd
_G.vcall = vim.call

_G.Klass = {}
function _G.Klass:new(_super)
    local klass, metatable, properties = {}, {}, {}
    klass.metatable = metatable
    klass.properties = properties

    function metatable:__index(_key)
        local prop = properties[_key]
        --- search local
        if prop then return prop.get(self)
        --- umm what
        elseif klass[_key] ~= nil then return klass[_key]
        --- search super
        elseif _super then return _super.metatable.__index(self, _key)
        --- fail
        else return nil end
    end

    function metatable:__newindex(_key, _value)
        local prop = properties[_key]
        --- check for local prop and set it --- OR ---
        if prop then return prop.set(self, _value)
        --- check for super and give it the new index --- OR ---
        elseif _super then return _super.metatable.__newindex(self, _key, _value)
        --- force setting instance value
        else rawset(self, _key, _value) end
    end

    function klass:new(...)
        local obj = setmetatable({}, self.metatable)
        if obj.__new then obj:__new(...) end
        return obj
    end

    return klass
end

return JK
