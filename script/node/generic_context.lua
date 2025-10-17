---@class Node.GenericContext: Class.Base
---@overload fun(scope: Scope, generics?: Node.Generic[]): Node.GenericContext
local M = Class 'Node.GenericContext'

M.kind = 'genericContext'

---@param scope Scope
---@param generics? Node.Generic[]
function M:__init(scope, generics)
    self.scope = scope
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
---@return Node.GenericContext
function M:resolve(map)
    local new = self.scope.node.genericContext(self.generics)
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

---@param self Node.GenericContext
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
