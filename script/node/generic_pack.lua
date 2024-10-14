---@class Node.GenericPack
---@overload fun(generics?: Node.Generic[]): Node.GenericPack
local M = Class 'Node.GenericPack'

---@param generics? Node.Generic[]
function M:__init(generics)
    self.generics = generics or {}
    ---@type table<string, Node>
    self.nodeMap = {}

    for _, generic in ipairs(self.generics) do
        self.nodeMap[generic.name] = generic
    end
end

---@param name string
---@param keepGeneric? boolean
---@return Node?
function M:getGeneric(name, keepGeneric)
    local v = self.nodeMap[name]
    if not v then
        return nil
    end
    if not keepGeneric and v.kind == 'generic' then
        ---@cast v Node.Generic
        return v.extends
    end
    return v
end

---@param resolved table<string, Node>
---@param keepGeneric? boolean
---@return Node.GenericPack
function M:resolve(resolved, keepGeneric)
    local new = ls.node.genericPack(self.generics)
    for k in pairs(self.nodeMap) do
        new.nodeMap[k] = resolved[k]
                      or (not keepGeneric and ls.node.UNKNOWN)
    end
    return new
end

---@param skipLevel? integer
---@return string
function M:view(skipLevel)
    local views = {}
    for i, generic in ipairs(self.generics) do
        local node = self.nodeMap[generic.name]
        if not node then
            views[i] = generic.name
            goto continue
        end
        if node.kind ~= 'generic' then
            views[i] = node:view(skipLevel)
            goto continue
        end
        ---@cast node Node.Generic
        if node.extends then
            views[i] = string.format('%s:%s', node.name, node.extends:view(skipLevel))
        else
            views[i] = node.name
        end
        ::continue::
    end
    return string.format('<%s>', table.concat(views, ', '))
end

---@param generics? Node.Generic[]
---@return Node.GenericPack
function ls.node.genericPack(generics)
    return New 'Node.GenericPack' (generics)
end
