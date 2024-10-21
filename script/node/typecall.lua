---@class Node.Typecall: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(scope: Scope, name: string, args: Node[]): Node.Typecall
local M = ls.node.register 'Node.Typecall'

M.kind = 'typecall'

---@param scope Scope
---@param name string
---@param args Node[]
function M:__init(scope, name, args)
    self.scope = scope
    self.head = scope.node.type(name)
    self.args = args
end

---@param self Node.Typecall
---@return Node
---@return true
M.__getter.value = function (self)
    return self.head:getValueWithArgs(self.args), true
end

function M:resolveGeneric(map)
    local args = ls.util.map(self.args, function (arg)
        return arg:resolveGeneric(map)
    end)
    return self.scope.node.typecall(self.head.typeName, args)
end

function M:view(skipLevel)
    if not self.head.params then
        return self.head.typeName
    end
    return string.format('%s<%s>'
        , self.head.typeName
        , table.concat(ls.util.map(self.head.params.generics, function (generic, i)
            local arg = self.args[i]
            if arg then
                return arg:view(skipLevel)
            end
            return generic.value:view(skipLevel)
        end), ', ')
    )
end
