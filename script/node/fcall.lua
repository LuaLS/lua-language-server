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
    self.inputs = args

    self.head:registerFlushChain(self)
end

---@type Node[]
M.args = nil

---@param self Node.FCall
---@return Node[]
---@return true
M.__getter.args = function (self)
    return ls.util.map(self.inputs, function (arg)
        if arg.kind == 'variable' then
            return arg.value
        else
            return arg
        end
    end), true
end

---@type Node
M.value = nil

---@param self Node.FCall
---@return Node
---@return true
M.__getter.value = function (self)
    self.value = self.scope.node.NEVER
    return self.returns:get(1), true
end

---@type Node
M.returns = nil

---@param self Node.FCall
---@return Node
---@return true
M.__getter.returns = function (self)
    local returns = {}
    local allMin = 0
    ---@type integer?
    local allMax = 0
    local hasDef

    local node = self.scope.node

    for f in self.head:finalValue():each 'function' do
        hasDef = true
        ---@cast f Node.Function
        f = f:resolveGeneric(f:makeGenericMap(self.args))
        local min, max = f:getReturnCount()
        for i = 1, min do
            returns[i] = returns[i] | f:getReturn(i)
        end
        if not allMin or allMin > min then
            allMin = min
        end
        if not max then
            allMax = nil
        elseif allMax and allMax < max then
            allMax = max
        end
    end

    if not hasDef then
        return node.UNKNOWN, true
    end

    local vararg = node.vararg(returns, allMin, allMax)
    return vararg, true
end

function M:resolveGeneric(map)
    local args = ls.util.map(self.args, function (arg)
        return arg:resolveGeneric(map)
    end)
    return self.scope.node.call(self.head.typeName, args)
end

ls.node.registerView('fcall', function(viewer, node)
    ---@cast node Node.FCall
    return '{}({})' % {
        node.head.typeName,
        table.concat(ls.util.map(node.args, function (arg)
            return viewer:view(arg)
        end), ', '),
    }
end)
