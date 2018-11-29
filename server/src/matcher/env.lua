local setmetatable = setmetatable
local pairs = pairs
local type = type
local table_sort = table.sort

return function (root)
    local env = {root}
    local is_table = {}
    for key, value in pairs(root) do
        if type(value) == 'table' then
            is_table[key] = true
        end
    end
    root._next = nil
    root._cut = {}

    local mt = { _env = env }
    function mt:push()
        env[#env+1] = { _next = env[#env], _cut = {} }
    end
    function mt:pop()
        env[#env] = nil
    end
    function mt:cut(key)
        env[#env]._cut[key] = true
    end
    function mt:__index(key)
        local origin = env[#env]
        if is_table[key] then
            return setmetatable({}, {
                __index = function (_, ckey)
                    local o = origin
                    while o do
                        local t = o[key]
                        if t and t[ckey] ~= nil then
                            return t[ckey]
                        end
                        o = not o._cut[key] and o._next
                    end
                end,
                __newindex = function (_, ckey, value)
                    local o = origin
                    if not o[key] then
                        o[key] = {}
                    end
                    o[key][ckey] = value
                end,
                __pairs = function ()
                    local o = origin
                    local tbl = {}
                    while o do
                        local t = o[key]
                        if t then
                            for k, v in pairs(t) do
                                if tbl[k] == nil then
                                    tbl[k] = v
                                end
                            end
                        end
                        o = not o._cut[key] and o._next
                    end
                    return next, tbl
                end,
            })
        else
            local o = origin
            while o do
                if o[key] ~= nil then
                    return o[key]
                end
                o = not o._cut[key] and o._next
            end
        end
    end
    function mt:__newindex(key, value)
        local o = env[#env]
        if is_table[key] then
            if type(o[key]) ~= 'table' then
                o[key] = {}
            end
            if type(value) == 'table' then
                for k, v in pairs(value) do
                    o[key][k] = v
                end
            else
                error(('[env.%s]是表，赋值也需要是表：[%s]'):format(key, value))
            end
        else
            o[key] = value
        end
    end
    function mt:__pairs()
        local keys = {}
        local cuted = {}
        local result = {}
        local o = env[#env]
        while true do
            for key in pairs(o._cut) do
                cuted[key] = true
            end
            for key, value in pairs(o) do
                if key == '_cut' or key == '_next' then
                    goto CONTINUE
                end
                if cuted[key] then
                    goto CONTINUE
                end
                if result[key] == nil then
                    keys[#keys+1] = key
                    if is_table[key] then
                        result[key] = {}
                    else
                        result[key] = value
                    end
                end
                if is_table[key] then
                    for k, v in pairs(value) do
                        if result[key][k] == nil then
                            result[key][k] = v
                        end
                    end
                end
                ::CONTINUE::
            end
            o = o._next
            if not o then
                break
            end
        end
        table_sort(keys)
        local i = 0
        return function ()
            i = i + 1
            local k = keys[i]
            return k, result[k]
        end
    end
    return setmetatable(mt, mt)
end
