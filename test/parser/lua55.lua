local parser = require 'parser'

print('[parser.lua55] 测试中...')

local ast = parser.compile([[global value
global<const> readonly
global *]], nil, {
    version = 'Lua 5.5',
})
assert(#ast.errors == 0)

local functionAst = parser.compile([[global function named(...args)
    return args[1], args.n, ...
end]], nil, {
    version = 'Lua 5.5',
})
if #functionAst.errors > 0 then
    local errors = {}
    for _, item in ipairs(functionAst.errors) do
        errors[#errors + 1] = item.errorCode .. '@' .. item.start
    end
    error(table.concat(errors, ','))
end

local scopedAst = parser.compile([[global known
known = 1
unknown = 2]], nil, {
    version = 'Lua 5.5',
})
assert(scopedAst.errors[1].errorCode == 'GLOBAL_NOT_DECLARED')

local shadowAst = parser.compile([[local value = 1
global value
value = 2]], nil, {
    version = 'Lua 5.5',
})
assert(#shadowAst.errors == 0)

local constAst = parser.compile([[global<const> readonly
readonly = 1]], nil, {
    version = 'Lua 5.5',
})
assert(constAst.errors[1].errorCode == 'SET_CONST')

local allConstAst = parser.compile([[global<const> *
implicit = 1]], nil, {
    version = 'Lua 5.5',
})
assert(allConstAst.errors[1].errorCode == 'SET_CONST')

local keywordAst = parser.compile([[global = 1
global()
local global = 2
function named(global)
    return global
end]], nil, {
    version = 'Lua 5.5',
})
assert(#keywordAst.errors == 0)

local globalAttrAst = parser.compile([[global<const> first, second <const>]], nil, {
    version = 'Lua 5.5',
})
assert(#globalAttrAst.errors == 0)

local invalidGlobalAttrAst = parser.compile('global<close> value', nil, {
    version = 'Lua 5.5',
})
assert(invalidGlobalAttrAst.errors[1].errorCode == 'UNKNOWN_ATTRIBUTE')

local forConstAst = parser.compile([[for i = 1, 2 do
    i = 3
end]], nil, {
    version = 'Lua 5.5',
})
assert(forConstAst.errors[1].errorCode == 'SET_CONST')

local genericForConstAst = parser.compile([[for key, value in pairs({}) do
    key = 1
    value = 2
end]], nil, {
    version = 'Lua 5.5',
})
assert(genericForConstAst.errors[1].errorCode == 'SET_CONST')

local genericForSecondAst = parser.compile([[for key, value in pairs({}) do
    value = 2
end]], nil, {
    version = 'Lua 5.5',
})
assert(#genericForSecondAst.errors == 0)

local oldForAst = parser.compile([[for i = 1, 2 do
    i = 3
end]], nil, {
    version = 'Lua 5.4',
})
assert(#oldForAst.errors == 0)

local prefixAttrAst = parser.compile([[local <const> value = 1
local <close> resource]], nil, {
    version = 'Lua 5.5',
})
assert(#prefixAttrAst.errors == 0)

local oldSyntaxAst = parser.compile([[local <const> value
function named(...args)
end]], nil, {
    version = 'Lua 5.4',
})
assert(oldSyntaxAst.errors[1].errorCode == 'UNSUPPORT_SYMBOL')

local oldGlobalAst = parser.compile([[global value
global *
global function f() end]], nil, {
    version = 'Lua 5.4',
})
for _, err in ipairs(oldGlobalAst.errors) do
    assert(err.errorCode == 'UNSUPPORT_SYMBOL', err.errorCode)
end
assert(#oldGlobalAst.errors == 3)
assert(#oldGlobalAst.nodesMap['globaldef'] == 2)
assert(#oldGlobalAst.nodesMap['function'] == 1)

local shadowAst = parser.compile([[local value
value = 1
global value
value = 2
local value
value = 3]], nil, {
    version = 'Lua 5.5',
})
assert(#shadowAst.errors == 0)
local shadowVars = shadowAst.nodesMap['var']
---@cast shadowVars LuaParser.Node.Var[]
assert(shadowVars[1].loc ~= nil)
assert(shadowVars[2].global == true)
assert(shadowVars[3].loc ~= nil)

local globalFuncInExplicitAst = parser.compile([[global x
global function f() end]], nil, {
    version = 'Lua 5.5',
})
assert(#globalFuncInExplicitAst.errors == 0)

local globalFuncShadowAst = parser.compile([[local f = 1
global function f() end]], nil, {
    version = 'Lua 5.5',
})
assert(#globalFuncShadowAst.errors == 0)

local prefixRangeAst = parser.compile('local <const> value', nil, {
    version = 'Lua 5.5',
})
assert(#prefixRangeAst.errors == 0)
local prefixLocals = prefixRangeAst.nodesMap['local']
---@cast prefixLocals LuaParser.Node.Local[]
local prefixLoc
for _, loc in ipairs(prefixLocals) do
    if loc.id == 'value' then
        prefixLoc = loc
    end
end
assert(prefixLoc ~= nil)
assert(prefixLoc.attr ~= nil)
assert(prefixLoc.start <= prefixLoc.finish)
assert(prefixLoc.start <= prefixLoc.attr.start)
assert(prefixLoc.attr.finish <= prefixLoc.finish)

print('[parser.lua55] 测试完毕')
