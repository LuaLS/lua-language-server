---@class Node.FCall: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(scope: Scope, head: Node, args: Node[]): Node.FCall
local M = ls.node.register 'Node.FCall'

M.kind = 'fcall'

---@type Node
M.head = nil

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
    return self.returns, true
end

function M:simplify()
    if self.value == self then
        return self
    end
    return self.value:simplify()
end

---@param key Node.Key
---@return Node
---@return boolean exists
function M:select(key)
    return self.returns:select(key)
end

---@type Node
M.returns = nil

---@param self Node.FCall
---@return Node
---@return true
M.__getter.returns = function (self)
    local returns = {}
    ---@type integer?, integer|false|nil
    local allMin, allMax

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
        local matches = {}
        for _, def in ipairs(defs) do
            if args:canCast(def.paramsPack) then
                matches[#matches+1] = def
            end
        end
        if #matches > 0 then
            defs = matches
        end
    end

    if #defs == 0 then
        return rt.UNKNOWN, true
    end

    local allParams = {}
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
    end

    local matches = rt:getBestMatchs(allParams, #self.args)
    for _, match in ipairs(matches) do
        local f = defs[match]
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
    for _, match in ipairs(matches) do
        local f = defs[match]
        f = f:resolveGeneric(f:makeGenericMap(self.args))
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
