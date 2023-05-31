require 'semantic.type'
require 'semantic.union'

local Type  = Class 'SType'
local files = require 'files'
local ws    = require 'workspace'

---@class Semantic
Semantic = {}

Semantic.bindMap = {}

---@alias SNode
---| SType
---| SUnion

-- 获取类型对象
---@param name string
---@return SType
function Semantic.getType(name)
    return Type.get(name)
end

-- 绑定语义
---@param source parser.object
---@param smt SNode
---@return SNode
function Semantic.bind(source, smt)
    Semantic.bindMap[source] = smt
    return smt
end

-- 获取绑定的语义
---@param source parser.object
---@return SNode?
function Semantic.get(source)
    return Semantic.bindMap[source]
end

-- 清除绑定的语义
---@param source parser.object
function Semantic.remove(source)
    Semantic.bindMap[source] = nil
end

-- 清空所有绑定的语义
function Semantic.clear()
    Semantic.bindMap = {}
end

-- 创建联合类型
---@param a SNode
---@param b SNode
---@return SUnion
function Semantic.newUnion(a, b)
    return New 'SUnion' (a, b)
end

files.watch(function (ev, uri)
    if ev == 'update' then
        Type.dropByUri(uri)
    end
    if ev == 'remove' then
        Type.dropByUri(uri)
    end
    if ev == 'compile' then
        local state = files.getLastState(uri)
        if state then
            Type.compileAst(state.ast)
        end
    end
    if ev == 'version' then
        if ws.isReady(uri) then
            Semantic.clear()
        end
    end
end)

ws.watch(function (ev, uri)
    if ev == 'reload' then
        Semantic.clear()
    end
end)
