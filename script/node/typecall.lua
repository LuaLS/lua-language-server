---@class Node.Typecall: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(name: string, args: Node[]): Node.Typecall
local M = ls.node.register 'Node.Typecall'

M.kind = 'typecall'

---@param name string
---@param args Node[]
function M:__init(name, args)
    self.head = ls.node.type(name)
    self.args = args
end

---@param self Node.Typecall
---@return Node
---@return true
M.__getter.value = function (self)
    return self.head:getValueWithArgs(self.args), true
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
            return (generic.default or generic.extends):view(skipLevel)
        end), ', ')
    )
end

ls.node.TYPE_CALL_POOL = ls.pathTable.create(true, true)

---@param name string
---@param args Node[]
---@return Node.Typecall
function ls.node.typecall(name, args)
    return New 'Node.Typecall' (name, args)
end
