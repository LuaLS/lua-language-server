local guide  = require 'guide'
local util   = require 'utility'
local state  = require 'vm.state'

---@class parser.guide.object
---@field _compiledGlobals      boolean
---@field _initedNodes          boolean
---@field _compiled             any

---@class vm.node.compiler
local m = {}

---@class vm.node.unknown
m.UNKNOWN = { type = 'unknown' }

local compilerMap = util.switch()
    : case 'setglobal'
    : call(function (uri, source)
        state.declareGlobal(source[1], uri, source)
    end)
    : call(function (uri, source)
        local global = state.getGlobal(source[1])
        global:addGet(uri, source)
    end)

---@param uri    uri
---@param source parser.guide.object
function m.compileNode(uri, source)
    if source._compiled then
        return
    end
    source._compiled = m.UNKNOWN
    local compiler = compilerMap[source.type]
    if compiler then
        compiler(uri, source)
    end
end

---编译全局变量的node
---@param  root parser.guide.object
function m.compileGlobals(root)
    if root._initedNodes then
        return
    end
    if root._compiledGlobals then
        return
    end
    root._compiledGlobals = true
    local uri = guide.getUri(root)
    local env = guide.getENV(root)
    for _, ref in ipairs(env.refs) do
        m.compileNode(uri, ref)
    end
end

return m
