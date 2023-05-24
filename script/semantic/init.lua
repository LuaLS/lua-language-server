require 'semantic.type'
require 'semantic.union'

local Type  = Class 'SType'
local files = require 'files'

---@class Semantic
Semantic = {}

---@alias SNode
---| SType
---| SUnion

-- 获取类型对象
---@param name string
---@return SType
function Semantic.getType(name)
    return Type.get(name)
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
end)
