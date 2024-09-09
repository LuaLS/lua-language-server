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
---@return GCNode
function M:insert(key, value)
    if not self.isClass then
        error('Node.Def:insert() only available for class')
    end
    if not self.fields then
        self.fields = ls.node.table()
    end
    self.fields:insert(key, value)
    return ls.gc.node(function () end)
end

function M:asClass()
    self.isClass = true
end

function M:asAlias()
    self.isAlias = true
end

function M:asEnum()
    self.isEnum = true
end

function M:view()
    if self.isClass then
        return 'class ' .. self.name
    end
    if self.isAlias then
        return 'alias ' .. self.name
    end
    if self.isEnum then
        return 'enum ' .. self.name
    end
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
