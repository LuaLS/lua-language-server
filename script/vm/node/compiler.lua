local guide    = require 'parser.guide'
local util     = require 'utility'
local state    = require 'vm.state'
local union    = require 'vm.node.union'

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
    return m.compileNode(guide.getUri(func), func._returns[index])
end

local function getReturn(func, index)
    local node = m.compileNode(guide.getUri(func), func)
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
    : call(function (uri, source, value)
        state.declareLiteral(uri, value)
        m.setNode(source, value)
    end)
    : case 'call'
    : call(function (uri, source, value)
        m.setNode(source, getReturn(value.node, 1))
    end)
    : getMap()

local function compileValue(uri, source, value)
    if not value then
        return
    end
    local f = valueMap[value.type]
    if f then
        f(uri, source, value)
    end
end

local compilerMap = util.switch()
    : case 'local'
    : call(function (uri, source)
        compileValue(uri, source, source.value)
        if source.ref then
            for _, ref in ipairs(source.ref) do
                if ref.type == 'setlocal' then
                    compileValue(uri, source, ref.value)
                end
            end
        end
    end)
    : case 'getlocal'
    : call(function (uri, source)
        m.setNode(source, m.compileNode(uri, source.node))
    end)
    : case 'setfield'
    : case 'getfield'
    : call(function (uri, source)
    end)
    : case 'function.return'
    : call(function (uri, source)
        
    end)
    : getMap()

---@param uri    uri
---@param source parser.object
---@return vm.node
function m.compileNode(uri, source)
    if source._node then
        return source._node
    end
    source._node = false
    local compiler = compilerMap[source.type]
    if compiler then
        compiler(uri, source)
    end
    state.subscribeLiteral(source, source._node)
    return source._node
end

return m
