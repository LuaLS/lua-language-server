---@class Node.ParamOf: Node
---@field func Node
---@field index integer
local M = ls.node.register 'Node.ParamOf'

M.kind = 'paramof'

---@param scope Scope
---@param func Node
---@param index integer
function M:__init(scope, func, index)
    self.scope = scope
    self.func  = func
    self.index = index
end

---@param self Node.ParamOf
---@return boolean
---@return true
M.__getter.hasGeneric = function (self)
    self.func:addRef(self)
    return self.func.hasGeneric, true
end

---@param map table<Node.Generic, Node>
---@param visited? table<Node, Node>
---@return Node
function M:resolveGeneric(map, visited)
    if not self.hasGeneric then
        return self
    end
    visited = visited or {}
    if visited[self] then
        return visited[self]
    end
    local func = self.func:resolveGeneric(map, visited)
    if func == self.func then
        return self
    end
    local newParamOf = self.scope.rt.paramOf(func, self.index)
    visited[self] = newParamOf
    return newParamOf
end

function M:simplify()
    if self.value == self then
        return self
    end
    return self.value:simplify()
end

---@param self Node.ParamOf
---@return Node
---@return true
M.__getter.value = function (self)
    self.func:addRef(self)

    local result
    local rt = self.scope.rt

    ---@param func Node.Function
    self.func:each('function', function (func)
        local r = func:getParam(self.index)
        if r then
            result = result | r
        end
    end)

    return result or rt.UNKNOWN, true
end
