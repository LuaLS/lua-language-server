---@class Node.Type: Node
---@operator bor(Node?): Node
---@operator shr(Node): boolean
---@overload fun(name: string): Node.Type
local M = ls.node.register 'Node.Type'

M.kind = 'type'

---@param name string
function M:__init(name)
    self.name = name
end

function M:view()
    return self.name
end

---@type { never: Node, any: Node.Any, unknown: Node.Unknown, [string]: Node.Type}
ls.node.TYPE = setmetatable({}, {
    __mode = 'v',
    __index = function (t, k)
        local v
        if k == 'never' then
            v = ls.node.NEVER
        elseif k == 'any' then
            v = ls.node.ANY
        elseif k == 'unknown' then
            v = ls.node.UNKNOWN
        else
            v = New 'Node.Type' (k)
        end
        t[k] = v
        return v
    end,
})

---@overload fun(name: 'never'): Node
---@overload fun(name: 'any'): Node.Any
---@overload fun(name: 'unknown'): Node.Unknown
---@overload fun(name: string): Node.Type
function ls.node.type(name)
    return ls.node.TYPE[name]
end
