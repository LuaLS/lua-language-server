---@class Node.GenericPack: Class.Base
---@overload fun(generics?: Node.Generic[]): Node.GenericPack
local M = Class 'Node.GenericPack'

M.kind = 'genericPack'

---@param generics? Node.Generic[]
function M:__init(generics)
    self.generics = generics or {}
    ---@type table<Node.Generic, Node>
    self.refMap = {}
end

---@param generic Node.Generic
---@return Node
function M:getGeneric(generic)
    return self.refMap[generic] or generic
end

---@param map table<Node.Generic, Node>
---@return Node.GenericPack
function M:resolve(map)
    local new = ls.node.genericPack(self.generics)
    for _, generic in ipairs(self.generics) do
        local value = map[generic]
        if value then
            new.refMap[generic] = value
        end
    end
    return new
end

---@type boolean
M.allResolved = nil

---@param self Node.GenericPack
---@return boolean
---@return true
M.__getter.allResolved = function (self)
    for _, generic in ipairs(self.generics) do
        local value = self.refMap[generic]
        if not value or value.kind == 'generic' then
            return false, true
        end
    end
    return true, true
end

---@param skipLevel? integer
---@return string
function M:view(skipLevel)
    local views = {}
    for i, generic in ipairs(self.generics) do
        local node = self:getGeneric(generic)
        if not node then
            views[i] = generic.name
            goto continue
        end
        if node.kind ~= 'generic' then
            views[i] = node:view(skipLevel)
            goto continue
        end
        ---@cast node Node.Generic
        views[i] = generic:view(skipLevel):sub(2, -2)
        ::continue::
    end
    return string.format('<%s>', table.concat(views, ', '))
end

---@param generics? Node.Generic[]
---@return Node.GenericPack
function ls.node.genericPack(generics)
    return New 'Node.GenericPack' (generics)
end
