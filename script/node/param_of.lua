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
    self:eachFunc(function (func)
        local r = func:getParam(self.index)
        if r then
            result = result | r
        end
    end)

    return result or rt.UNKNOWN, true
end

--- 遍历 func 的所有 function 定义（含 master 与等价值），当前值被覆盖时也能取到全部
---@param callback fun(func: Node.Function)
function M:eachFunc(callback)
    local func = self.func
    ---@type Node[]
    local sources = { func }
    ---@type Node.Variable?
    local master
    if func.kind == 'variable' then
        ---@cast func Node.Variable
        master = func.masterVariable or func
    end
    if master then
        if master ~= func then
            sources[#sources+1] = master
        end
        local ev = master.equivalentValue
        if ev and ev ~= master then
            sources[#sources+1] = ev
        end
    end
    for _, src in ipairs(sources) do
        src:each('function', callback)
    end
end

--- 返回参数声明的期望类型（泛型约束或直接声明类型）；无注解返回 nil
---@return Node?
function M:getExpectValue()
    local result
    ---@param func Node.Function
    self:eachFunc(function (func)
        if result then
            return
        end
        local pd = func.paramsDef and func.paramsDef[self.index]
        if not pd or not pd.value then
            return
        end
        local t = pd.value
        -- 泛型引用（variable -> generic）
        if t.kind == 'variable' then
            t = t.value
        end
        if t and t.kind == 'generic' then
            ---@cast t Node.Generic
            t = t.extends
        end
        if t then
            -- 无注解参数推断为 any，跳过（不当作期望类型）
            if t.kind == 'type' and t.typeName == 'any' then
                return
            end
            result = t
        end
    end)
    return result
end
