local guide  = require 'parser.guide'
local util   = require 'utility'
local state  = require 'vm.state'

---@class parser.guide.object
---@field _compiledGlobal boolean
---@field _compiledNodes  boolean
---@field _compiled       any
---@field _globalID       string

---@class vm.node.compiler
local m = {}

---@class vm.node.unknown
m.UNKNOWN = { type = 'unknown' }

---@alias vm.node vm.node.unknown | vm.node.global | vm.node.class

local compilerMap = util.switch()
    : getMap()

---@param uri    uri
---@param source parser.guide.object
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
    end)
    : getMap()

---@param uri    uri
---@param source parser.guide.object
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
---@param  root parser.guide.object
function m.compileGlobals(root)
    if root._compiledGlobal then
        return
    end
    root._compiledGlobal = true
    local uri = guide.getUri(root)
    local env = guide.getENV(root)
    if env.ref then
        for _, ref in ipairs(env.ref) do
            m.compileGlobalNode(uri, ref)
        end
    end
end

return m
