local guide  = require 'parser.guide'
local util   = require 'utility'
local state  = require 'vm.state'

---@class parser.object
---@field _compiledNodes  boolean
---@field _compiled       any
---@field _globalID       vm.node.global

---@class vm.node.compiler
local m = {}

---@class vm.node.unknown
m.UNKNOWN = { type = 'unknown' }
m.GLOBAL_SPLITE = '\x1F'

---@alias vm.node vm.node.unknown | vm.node.global | vm.node.class

---@param  ... string
---@return string
function m.getGlobalID(...)
    return table.concat({...}, m.GLOBAL_SPLITE)
end

local compilerMap = util.switch()
    : case 'local'
    : call(function (uri, source)
        local value = source.value
        if not value then
            return
        end
        if value.type == 'table'
        or value.type == 'integer'
        or value.type == 'number'
        or value.type == 'string'
        or value.type == 'function' then
            source._compiled = value
            state.declareLiteral(uri, value)
            state.subscribeLiteral(value, source)
        end
    end)
    : case 'getlocal'
    : call(function (uri, source)
        source._compiled = m.compileNode(uri, source.node)
    end)
    : getMap()

---@param uri    uri
---@param source parser.object
---@return vm.node
function m.compileNode(uri, source)
    if source._compiled then
        return source._compiled
    end
    source._compiled = m.UNKNOWN
    local compiler = compilerMap[source.type]
    if compiler then
        compiler(uri, source)
    end
    return source._compiled
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
