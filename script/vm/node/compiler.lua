local guide    = require 'parser.guide'
local util     = require 'utility'
local state    = require 'vm.state'
local union    = require 'vm.node.union'
local localID  = require 'vm.local-id'

---@class parser.object
---@field _compiledNodes  boolean
---@field _node           vm.node

---@class vm.node.compiler
local m = {}

---@class vm.node.cross

---@alias vm.node parser.object | vm.node.union | vm.node.cross

function m.setNode(source, node)
    if not node then
        return
    end
    local me = source._node
    if not me then
        source._node = node
        return
    end
    if me.type == 'union'
    or me.type == 'cross' then
        me:merge(node)
        return
    end
    source._node = union(me, node)
end

function m.eachNode(node)
    if node.type == 'union' then
        return node:eachNode()
    end
    local first = true
    return function ()
        if first then
            first = false
            return node
        end
        return nil
    end
end

local function getReturnOfFunction(func, index)
    if not func._returns then
        func._returns = util.defaultTable(function ()
            return {
                type   = 'function.return',
                parent = func,
                index  = index,
            }
        end)
    end
    return m.compileNode(func._returns[index])
end

local function getReturn(func, index)
    local node = m.compileNode(func)
    if not node then
        return
    end
    for cnode in m.eachNode(node) do
        if cnode.type == 'function' then
            return getReturnOfFunction(cnode, index)
        end
    end
end

local valueMap = util.switch()
    : case 'boolean'
    : case 'table'
    : case 'integer'
    : case 'number'
    : case 'string'
    : case 'function'
    : call(function (source, value)
        state.declareLiteral(value)
        m.setNode(source, value)
    end)
    : case 'select'
    : call(function (source, value)
        local vararg = value.vararg
        if vararg.type == 'call' then
            m.setNode(source, getReturn(vararg.node, value.sindex))
        end
    end)
    : getMap()

local function compileValue(source, value)
    if not value then
        return
    end
    local f = valueMap[value.type]
    if f then
        f(source, value)
    end
end

local function compileByLocalID(source)
    local sources = localID.getSources(source)
    if not sources then
        return
    end
    for _, src in ipairs(sources) do
        if src.value then
            compileValue(source, src.value)
        end
    end
end

local searchFieldMap = util.switch()
    : case 'table'
    : call(function (node, key, pushResult)
        for _, field in ipairs(node) do
            if field.type == 'tablefield'
            or field.type == 'tableindex' then
                if guide.getKeyName(field) == key then
                    pushResult(field)
                end
            end
        end
    end)
    : getMap()

local function compileByParentNode(source)
    local parentNode = m.compileNode(source.node)
    if not parentNode then
        return
    end
    local key = guide.getKeyName(source)
    local f = searchFieldMap[parentNode.type]
    if f then
        f(parentNode, key, function (field)
            compileValue(source, field.value)
        end)
    end
end

local compilerMap = util.switch()
    : case 'local'
    : call(function (source)
        compileValue(source, source.value)
        if source.ref then
            for _, ref in ipairs(source.ref) do
                if ref.type == 'setlocal' then
                    compileValue(source, ref.value)
                end
            end
        end
    end)
    : case 'getlocal'
    : call(function (source)
        m.setNode(source, m.compileNode(source.node))
    end)
    : case 'setfield'
    : case 'setmethod'
    : case 'setindex'
    : call(function (source)
        compileByLocalID(source)
    end)
    : case 'getfield'
    : case 'getmethod'
    : case 'getindex'
    : call(function (source)
        compileByLocalID(source)
        compileByParentNode(source)
    end)
    : case 'function.return'
    : call(function (source)
        local func  = source.parent
        local index = source.index
        if func.returns then
            for _, rtn in ipairs(func.returns) do
                if rtn[index] then
                    m.setNode(source, m.compileNode(rtn[index]))
                end
            end
        end
    end)
    : getMap()

---@param source parser.object
---@return vm.node
function m.compileNode(source)
    if source._node then
        return source._node
    end
    source._node = false
    local compiler = compilerMap[source.type]
    if compiler then
        compiler(source)
    end
    state.subscribeLiteral(source, source._node)
    return source._node
end

return m
