---@class Node.Typecall: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(name: string, nodes: Node[]): Node.Typecall
local M = ls.node.register 'Node.Typecall'

M.kind = 'typecall'

---@param name string
---@param nodes Node[]
function M:__init(name, nodes)
    self.head = ls.node.type(name)
    self.params = nodes
end

function M:view(skipLevel)
    return string.format('%s<%s>'
        , self.head.typeName
        , table.concat(ls.util.map(self.params, function (param)
            return param:view(skipLevel)
        end), ', ')
    )
end

ls.node.TYPE_CALL_POOL = ls.pathTable.create(true, true)

---@param name string
---@param nodes Node[]
---@return Node.Typecall
function ls.node.typecall(name, nodes)
    return New 'Node.Typecall' (name, nodes)
end
