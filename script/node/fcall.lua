---@class Node.FCall: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(scope: Scope, head: Node, args: Node[]): Node.FCall
local M = ls.node.register 'Node.FCall'

M.kind = 'fcall'

---@type Node
M.head = nil

---@type Node.Location?
M.location = nil

--- 可选链调用标记：值总是包含 nil
---@private
M._optional = false

---@param location Node.Location
---@return Node.FCall
function M:setLocation(location)
    self.location = location
    return self
end

--- 标记为可选链调用（?(），其值总是包含 nil
---@return Node.FCall
function M:setOptional()
    self._optional = true
    return self
end

---@return boolean
function M:isOptional()
    return self._optional or false
end

---@param scope Scope
---@param head Node
---@param args Node[]
function M:__init(scope, head, args)
    self.scope = scope
    self.head = head
    self.args = args
end

---@type Node
M.value = nil

---@param self Node.FCall
---@return Node
---@return true
M.__getter.value = function (self)
    self.value = self.scope.rt.NEVER
    local result = self.returns
    -- 可选链调用（?(）：结果总是包含 nil
    if self:isOptional() then
        result = result | self.scope.rt.NIL
    end
    return result, true
end

---@param self Node.FCall
---@return string
---@return true
M.__getter.typeName = function (self)
    return self.value.typeName, true
end

---@param other Node
---@return boolean
function M:onCanCast(other)
    return self.value:canCast(other)
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

---@param key Node.Key
---@return Node
---@return boolean exists
function M:select(key)
    local v, exists = self.returns:select(key)
    -- 可选链调用（?(）：所有位置的值都可能为 nil
    if self:isOptional() then
        v = v | self.scope.rt.NIL
    end
    return v, exists
end

---@type Node
M.returns = nil

---@type Node.Function[]
M.matchedFuncs = nil

---@param self Node.FCall
---@return Node.Function[]
---@return true
M.__getter.matchedFuncs = function (self)
    local rt = self.scope.rt
    ---@type Node.Function[]
    local defs = {}
    local args = rt.list(self.args)

    self.head:addRef(self)
    args:addRef(self)

    self.head:each('function', function (f)
        ---@cast f Node.Function
        if not f:isDummy() then
            defs[#defs+1] = f
        end
    end)

    if #defs > 1 then
        local filtered = {}
        for _, def in ipairs(defs) do
            if args:canCast(def.paramsPack) then
                filtered[#filtered+1] = def
            end
        end
        if #filtered > 0 then
            defs = filtered
        end
    end

    if #defs == 0 then
        return {}, true
    end

    local allParams = {}
    local allPacks = {}
    for i, def in ipairs(defs) do
        local params = ls.util.map(def.paramsDef, function (v)
            local value = v.value
            if value.kind == 'generic' then
                ---@cast value Node.Generic
                return value.extends
            else
                return value
            end
        end)
        allParams[i] = params
        allPacks[i] = def.paramsPack
    end

    local matches = rt:getBestMatchs(allParams, #self.args, allPacks)
    local ctx = ls.node.resolveContext(self.location)
    local result = {}
    for _, match in ipairs(matches) do
        local f = defs[match]
        result[#result+1] = f:resolveGeneric(f:makeGenericMap(self.args), ctx)
    end
    return result, true
end

---@param self Node.FCall
---@return Node
---@return true
M.__getter.returns = function (self)
    local returns = {}
    ---@type integer?, integer|false|nil
    local allMin, allMax

    local rt = self.scope.rt
    local matchedFuncs = self.matchedFuncs

    if #matchedFuncs == 0 then
        return rt.ANY, true
    end

    for _, f in ipairs(matchedFuncs) do
        local min, max = f:getReturnCount()
        if not allMin or allMin < min then
            allMin = min
        end
        if not max then
            allMax = false
        elseif allMax and allMax < max then
            allMax = max
        end
    end
    for _, f in ipairs(matchedFuncs) do
        for i = 1, allMin do
            returns[i] = returns[i] | (f:getReturn(i) or rt.NIL)
        end
    end

    local list = rt.list(returns, allMin, allMax)
    return list, true
end

function M:onView(viewer, options)
    return '{}({})' % {
        viewer:view(self.head, {
            needParentheses = true,
        }),
        table.concat(ls.util.map(self.args, function (arg)
            return viewer:view(arg)
        end), ', '),
    }
end
