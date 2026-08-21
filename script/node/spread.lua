---@class Node.Spread: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(scope: Scope, head: Node): Node.Spread
local M = ls.node.register 'Node.Spread'

M.kind = 'spread'

---@param scope Scope
---@param head Node
function M:__init(scope, head)
    self.scope = scope
    self.head  = head
end

---@param self Node.Spread
---@return Node
---@return true
M.__getter.value = function (self)
    local rt = self.scope.rt
    self.head:addRef(self)

    local head = self.head:simplify()
    for _ = 1, 100 do
        if head.kind ~= 'variable'
        and head.kind ~= 'intersection' then
            break
        end
        head:addRef(self)
        local value = head.value
        if value == head then
            break
        end
        head = value:simplify()
    end
    if head.kind == 'list' then
        return head, true
    end
    if head.kind == 'tuple' then
        ---@cast head Node.Tuple
        return head.values, true
    end
    if head.kind == 'array' then
        ---@cast head Node.Array
        return rt.list({ head.head }, 0, false), true
    end
    if head.kind == 'table' then
        ---@cast head Node.Table
        local maxn = 0
        for _, key in ipairs(head.keys) do
            local literal
            if type(key) == 'number' then
                literal = key
            elseif key.kind == 'value' then
                literal = key.literal
            end
            if math.type(literal) == 'integer' then
                ---@cast literal integer
                if  literal >= 1
                and literal > maxn then
                    maxn = literal
                end
            end
        end
        if maxn > 0 then
            local values = {}
            for i = 1, maxn do
                local v, exists = head:get(i)
                values[i] = exists and v or rt.NIL
            end
            return rt.list(values), true
        end
    end
    return rt.list({ self.head }), true
end

---@param self Node.Spread
---@return string
---@return true
M.__getter.typeName = function (self)
    return self.value.typeName, true
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
    return self.value:select(key)
end

---@param other Node
---@return boolean
function M:onCanCast(other)
    return self.value:canCast(other)
end

---@param other Node
---@return boolean?
function M:onCanBeCast(other)
    if self.hasGeneric then
        return true
    end
    return self.value:canCast(other)
end

---@param self Node.Spread
---@return boolean
---@return true
M.__getter.hasGeneric = function (self)
    self.head:addRef(self)
    return self.head.hasGeneric, true
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
    local head = self.head:resolveGeneric(map, ctx)
    if head == self.head then
        return self
    end
    local newSpread = self.scope.rt.spread(head)
    ctx.visited[self] = newSpread
    return newSpread
end

function M:inferGeneric(other, result)
    if not self.hasGeneric then
        return
    end
    local generic = self.head:findValue(ls.node.kind['generic'])
    ---@cast generic Node.Generic?
    if not generic then
        return
    end
    if result[generic] then
        return
    end
    local rt = self.scope.rt
    local list = other:findValue(ls.node.kind['list']) or rt.list({ other })
    result[generic] = rt.tuple(list)
end

function M:onView(viewer, options)
    local generic = self.head:findValue(ls.node.kind['generic'])
    ---@cast generic Node.Generic?
    if generic then
        return '...' .. generic.name
    end
    return '...' .. viewer:view(self.head, {
        needParentheses = true,
    })
end

function M:onViewAsList(viewer, options)
    return self.value:onViewAsList(viewer, options)
end
