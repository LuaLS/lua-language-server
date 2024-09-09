---@class Node.Def: Node
---@overload fun(name: string): Node.Def
local M = Class('Node.Def', 'Node')

M.kind = 'def'

---@param name string
function M:__init(name)
    self.name = name
end

---@param key Node.Value
---@param value Node
---@return Node.Def
function M:insert(key, value)
    if not self.fields then
        self.fields = ls.node.table()
    end
    self.fields:insert(key, value)
    return self
end

function M:view()
    return self.name
end

---@type { [string]: Node.Def }
ls.node.DEF = setmetatable({}, {
    __mode = 'v',
    __index = function (t, k)
        local v = New 'Node.Def' (k)
        t[k] = v
        return v
    end,
})

---@param name string
---@return Node.Def
function ls.node.def(name)
    return ls.node.DEF[name]
end
