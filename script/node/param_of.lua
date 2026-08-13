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
---@param ctx? Node.ResolveContext
---@return Node
function M:resolveGeneric(map, ctx)
    if not self.hasGeneric then
        return self
    end
    ctx = ctx or ls.node.resolveContext()
    if ctx.visited[self] then
        return ctx.visited[self]
    end
    local func = self.func:resolveGeneric(map, ctx)
    if func == self.func then
        return self
    end
    local newParamOf = self.scope.rt.paramOf(func, self.index)
    ctx.visited[self] = newParamOf
    return newParamOf
end

---@param visited? table<Node, true>
---@return Node
function M:simplify(visited)
    if self.value == self then
        return self
    end
    visited = visited or {}
    if visited[self] then
        return self
    end
    visited[self] = true
    return self.value:simplify(visited)
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
