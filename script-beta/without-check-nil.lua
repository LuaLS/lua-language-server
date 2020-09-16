local m = {}

local mt = {}
mt.__add      = function (a, b)
    if a == nil then a = 0 end
    if b == nil then b = 0 end
    return a + b
end
mt.__sub      = function (a, b)
    if a == nil then a = 0 end
    if b == nil then b = 0 end
    return a - b
end
mt.__mul      = function (a, b)
    if a == nil then a = 0 end
    if b == nil then b = 0 end
    return a * b
end
mt.__div      = function (a, b)
    if a == nil then a = 0 end
    if b == nil then b = 0 end
    return a / b
end
mt.__mod      = function (a, b)
    if a == nil then a = 0 end
    if b == nil then b = 0 end
    return a % b
end
mt.__pow      = function (a, b)
    if a == nil then a = 0 end
    if b == nil then b = 0 end
    return a ^ b
end
mt.__unm      = function ()
    return 0
end
mt.__concat   = function (a, b)
    if a == nil then a = '' end
    if b == nil then b = '' end
    return a .. b
end
mt.__len      = function ()
    return 0
end
mt.__lt       = function (a, b)
    if a == nil then a = 0 end
    if b == nil then b = 0 end
    return a < b
end
mt.__le       = function (a, b)
    if a == nil then a = 0 end
    if b == nil then b = 0 end
    return a <= b
end
mt.__index    = function () end
mt.__newindex = function () end
mt.__call     = function () end
mt.__pairs    = function () end
mt.__ipairs   = function () end
if _VERSION == 'Lua 5.3' or _VERSION == 'Lua 5.4' then
    mt.__idiv      = load[[
        local a, b = ...
        if a == nil then a = 0 end
        if b == nil then b = 0 end
        return a // b
    ]]
    mt.__band      = load[[
        local a, b = ...
        if a == nil then a = 0 end
        if b == nil then b = 0 end
        return a & b
    ]]
    mt.__bor       = load[[
        local a, b = ...
        if a == nil then a = 0 end
        if b == nil then b = 0 end
        return a | b
    ]]
    mt.__bxor      = load[[
        local a, b = ...
        if a == nil then a = 0 end
        if b == nil then b = 0 end
        return a ~ b
    ]]
    mt.__bnot      = load[[
        return ~ 0
    ]]
    mt.__shl       = load[[
        local a, b = ...
        if a == nil then a = 0 end
        if b == nil then b = 0 end
        return a << b
    ]]
    mt.__shr       = load[[
        local a, b = ...
        if a == nil then a = 0 end
        if b == nil then b = 0 end
        return a >> b
    ]]
end

for event, func in pairs(mt) do
    mt[event] = function (...)
        local watch = m.watch
        if not watch then
            return func(...)
        end
        local care, result = watch(event, ...)
        if not care then
            return func(...)
        end
        return result
    end
end

function m.enable()
    debug.setmetatable(nil, mt)
end

function m.disable()
    if debug.getmetatable(nil) == mt then
        debug.setmetatable(nil, nil)
    end
end

return m
