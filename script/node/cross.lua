---@class Node.Cross: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(nodes?: Node[]): Node.Cross
local M = ls.node.register 'Node.Cross'

M.kind = 'cross'

---@param nodes? Node[]
function M:__init(nodes)
    ---@package
    self.rawNodes = nodes or {}
end

---@type Node
M.value = nil

---@param self Node.Cross
---@return Node
---@return true
M.__getter.value = function (self)
    local value = self.rawNodes[1]
    if value.kind == 'union' then
        ---@cast value Node.Union
        value = value:simplify() or ls.node.NIL
    end
    for i = 2, #self.rawNodes do
        local other = self.rawNodes[i]
        if other.kind == 'union' then
            ---@cast other Node.Union
            other = other:simplify() or ls.node.NIL
        end
        if other.kind == 'cross' then
            ---@cast other Node.Cross
            other = other.value
        end
        if value >> other then
            goto continue
        end
        if other >> value then
            value = other
            goto continue
        end
        if value.kind == 'union' then
            ---@cast value Node.Union
            local values = {}
            for _, v in ipairs(value.values) do
                local vv = v & other
                if vv ~= ls.node.NEVER then
                    values[#values+1] = vv
                end
            end
            if #values == 0 then
                value = ls.node.NEVER
                break
            end
            value = ls.node.union(values)
            goto continue
        end
        value = ls.node.NEVER
        break
        ::continue::
    end
    return value, true
end

function M:view(skipLevel)
    return self.value:view(skipLevel)
end

---@param nodes? Node[]
---@return Node.Cross
function ls.node.cross(nodes)
    return New 'Node.Cross' (nodes)
end
