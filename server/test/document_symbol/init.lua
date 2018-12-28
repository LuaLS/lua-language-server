local parser = require 'parser'
local core = require 'core'

local SymbolKind = {
    File = 1,
    Module = 2,
    Namespace = 3,
    Package = 4,
    Class = 5,
    Method = 6,
    Property = 7,
    Field = 8,
    Constructor = 9,
    Enum = 10,
    Interface = 11,
    Function = 12,
    Variable = 13,
    Constant = 14,
    String = 15,
    Number = 16,
    Boolean = 17,
    Array = 18,
    Object = 19,
    Key = 20,
    Null = 21,
    EnumMember = 22,
    Struct = 23,
    Event = 24,
    Operator = 25,
    TypeParameter = 26,
}

rawset(_G, 'TEST', true)

local EXISTS = {}

local function eq(a, b)
    if a == EXISTS and b ~= nil then
        return true
    end
    local tp1, tp2 = type(a), type(b)
    if tp1 ~= tp2 then
        return false
    end
    if tp1 == 'table' then
        local mark = {}
        for k in pairs(a) do
            if not eq(a[k], b[k]) then
                return false
            end
            mark[k] = true
        end
        for k in pairs(b) do
            if not mark[k] then
                return false
            end
        end
        return true
    end
    return a == b
end

function TEST(script)
    return function (expect)
        local ast = parser:ast(script)
        local vm = core.vm(ast)
        assert(vm)
        local result = core.documentSymbol(vm)
        assert(eq(expect, result))
    end
end

TEST [[
local function f()
end
]]
{
    [1] = {
        name = 'f',
        detail = 'function f()',
        kind = SymbolKind.Function,
        range = {1, 22},
        selectionRange = {16, 16},
    }
}

TEST [[
function f()
end
]]
{
    [1] = {
        name = 'f',
        detail = 'function f()',
        kind = SymbolKind.Function,
        range = {1, 16},
        selectionRange = {10, 10},
    }
}

TEST [[
return function ()
end
]]
{
    [1] = {
        name = '',
        detail = 'function ()',
        kind = SymbolKind.Function,
        range = {8, 22},
        selectionRange = {8, 8},
    }
}

--TEST [[
--local f = function ()
--end
--]]
--{
--    [1] = {
--        name = 'f',
--        detail = 'function f()',
--        kind = SymbolKind.Function,
--        range = {11, 25},
--        selectionRange = {11, 11},
--    }
--}
