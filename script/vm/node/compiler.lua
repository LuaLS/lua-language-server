local guide = require 'parser.guide'
local util  = require 'utility'
local state = require 'vm.state'
local union = require 'vm.node.union'

---@class parser.object
---@field _compiledNodes  boolean
---@field _node           vm.node
---@field _globalID       vm.node.global

---@class vm.node.compiler
local m = {}

---@class vm.node.cross

m.GLOBAL_SPLITE = '\x1F'

---@alias vm.node parser.object | vm.node.union | vm.node.cross

---@param  ... string
---@return string
function m.getGlobalID(...)
    return table.concat({...}, m.GLOBAL_SPLITE)
end

function m.setNode(source, node)
    local me = source._node
    if not me then
        source._node = node
        return
    end
    if me.type == 'union'
    or me.type == 'cross' then
        me:merge(source, node)
        return
    end
    source._node = union(source, node)
end

local function compileValue(uri, source, value)
    if not value then
        return
    end
    if value.type == 'table'
    or value.type == 'integer'
    or value.type == 'number'
    or value.type == 'string'
    or value.type == 'function' then
        state.declareLiteral(uri, value)
        m.setNode(source, value)
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

local compilerGlobalMap = util.switch()
    : case 'local'
    : call(function (uri, source)
        if source.tag ~= '_ENV' then
            return
        end
        if source.ref then
            for _, ref in ipairs(source.ref) do
                m.compileGlobalNode(uri, ref)
            end
        end
    end)
    : case 'setglobal'
    : call(function (uri, source)
        local name = guide.getKeyName(source)
        source._globalID = state.declareGlobal(name, uri, source)
    end)
    : case 'getglobal'
    : call(function (uri, source)
        local name   = guide.getKeyName(source)
        local global = state.getGlobal(name)
        global:addGet(uri, source)
        source._globalID = global

        local nxt = source.next
        if nxt then
            m.compileGlobalNode(uri, nxt)
        end
    end)
    : case 'setfield'
    ---@param uri    uri
    ---@param source parser.object
    : call(function (uri, source)
        local parent = source.node._globalID
        if not parent then
            return
        end
        local name = m.getGlobalID(parent:getName(), guide.getKeyName(source))
        source._globalID = state.declareGlobal(name, uri, source)
    end)
    : case 'getfield'
    ---@param uri    uri
    ---@param source parser.object
    : call(function (uri, source)
        local parent = source.node._globalID
        if not parent then
            return
        end
        local name = m.getGlobalID(parent:getName(), guide.getKeyName(source))
        local global = state.getGlobal(name)
        global:addGet(uri, source)
        source._globalID = global

        local nxt = source.next
        if nxt then
            m.compileGlobalNode(uri, nxt)
        end
    end)
    : getMap()

---@param uri    uri
---@param source parser.object
function m.compileGlobalNode(uri, source)
    if source._globalID ~= nil then
        return
    end
    source._globalID = false
    local compiler = compilerGlobalMap[source.type]
    if compiler then
        compiler(uri, source)
    end
end

---编译全局变量的node
---@param  root parser.object
function m.compileGlobals(root)
    local uri = guide.getUri(root)
    local env = guide.getENV(root)
    m.compileGlobalNode(uri, env)
end

return m
