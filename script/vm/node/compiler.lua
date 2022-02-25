local guide     = require 'parser.guide'
local util      = require 'utility'
local union     = require 'vm.node.union'
local localID   = require 'vm.local-id'
local localMgr  = require 'vm.local-manager'
local globalMgr = require 'vm.global-manager'

---@class parser.object
---@field _compiledNodes  boolean
---@field _node           vm.node

---@class vm.node.compiler
local m = {}

---@class vm.node.cross

---@alias vm.node parser.object | vm.node.union | vm.node.cross | vm.node.global

function m.setNode(source, node)
    if not node then
        return
    end
    local me = source._node
    if not me then
        source._node = node
        return
    end
    if me == node then
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

local searchFieldMap = util.switch()
    : case 'table'
    : call(function (node, key, pushResult)
        for _, field in ipairs(node) do
            if field.type == 'tablefield'
            or field.type == 'tableindex' then
                if guide.getKeyName(field) == key then
                    pushResult(m.compileNode(field))
                end
            end
        end
    end)
    : case 'global'
    ---@param node vm.node.global
    : call(function (node, key, pushResult)
        local global = globalMgr.getGlobal(node.name, key)
        if global then
            pushResult(global)
        end
    end)
    : case 'local'
    : call(function (node, key, pushResult)
        local sources = localID.getSources(node, key)
        if sources then
            for _, src in ipairs(sources) do
                pushResult(m.compileNode(src))
            end
        end
    end)
    : getMap()

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

local function getReturnOfSetMetaTable(source, args)
    local tbl = args and args[1]
    local mt  = args and args[2]
    if tbl then
        m.setNode(source, m.compileNode(tbl))
    end
    if mt then
        m.compileByParentNode(mt, '__index', function (node)
            m.setNode(source, node)
        end)
    end
    return source._node
end

local function getReturn(func, index, source, args)
    local node = m.compileNode(func)
    if not node then
        return
    end
    for cnode in m.eachNode(node) do
        if     cnode.type == 'function' then
            return getReturnOfFunction(cnode, index)
        elseif cnode.type == 'global' then
            if cnode.name == 'setmetatable' and index == 1 then
                return getReturnOfSetMetaTable(source, args)
            end
        end
    end
end

local function compileByLocalID(source)
    local sources = localID.getSources(source)
    if not sources then
        return
    end
    for _, src in ipairs(sources) do
        if src.value then
            m.setNode(source, m.compileNode(src.value))
        end
    end
end

---@param source vm.node
---@param key any
---@param pushResult fun(node:vm.node)
function m.compileByParentNode(source, key, pushResult)
    local parentNode = m.compileNode(source)
    if not parentNode then
        return
    end
    for node in m.eachNode(parentNode) do
        local f = searchFieldMap[node.type]
        if f then
            f(node, key, pushResult)
        end
    end
end

local compilerMap = util.switch()
    : case 'boolean'
    : case 'table'
    : case 'integer'
    : case 'number'
    : case 'string'
    : case 'function'
    : call(function (source)
        localMgr.declareLocal(source)
        m.setNode(source, source)
    end)
    : case 'local'
    : call(function (source)
        m.setNode(source, source)
        if source.value then
            m.setNode(source, m.compileNode(source.value))
        end
        if source.ref then
            for _, ref in ipairs(source.ref) do
                if ref.type == 'setlocal' then
                    m.setNode(source, m.compileNode(ref.value))
                end
            end
        end
        if source.dummy then
            m.setNode(source, m.compileNode(source.method.node))
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
        m.compileByParentNode(source.node, guide.getKeyName(source), function (node)
            m.setNode(source, node)
        end)
    end)
    : case 'tablefield'
    : case 'tableindex'
    : call(function (source)
        if source.value then
            m.setNode(source, m.compileNode(source.value))
        end
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
    : case 'select'
    : call(function (source)
        local vararg = source.vararg
        if vararg.type == 'call' then
            m.setNode(source, getReturn(vararg.node, source.sindex, source, vararg.args))
        end
    end)
    : getMap()

---@param source parser.object
---@return vm.node
function m.compileNode(source)
    if source._node ~= nil then
        return source._node
    end
    source._node = false
    local compiler = compilerMap[source.type]
    if compiler then
        compiler(source)
    end
    localMgr.subscribeLocal(source, source._node)
    if source._globalNode then
        m.setNode(source, source._globalNode)
    end
    return source._node
end

return m
