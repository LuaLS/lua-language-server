---@class Node.Alias: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
local M = ls.node.register 'Node.Alias'

M.kind = 'alias'

---@param scope Scope
---@param name string
---@param params? Node.Generic[]
---@param value? Node
function M:__init(scope, name, params, value)
    self.aliasName = name
    self.scope = scope
    self.params = params
    self.value = value
end

---@param param Node.Generic
---@return Node.Alias
function M:addTypeParam(param)
    if not self.params then
        self.params = {}
    end
    table.insert(self.params, param)
    return self
end

---@param value Node
---@return Node.Alias
function M:setValue(value)
    self.value = value
    return self
end

---@type Node.Location?
M.location = nil

---@param location Node.Location
function M:setLocation(location)
    self.location = location
end

---@param self Node.Class
---@return boolean
---@return true
M.__getter.hasGeneric = function (self)
    return self.params ~= nil, true
end

---@param map table<Node.Generic, Node>
---@return Node
function M:resolveGeneric(map)
    if not self.params then
        return self
    end
    return self.value:resolveGeneric(map)
end

---@param args Node[]
---@return table<Node.Generic, Node>
function M:makeGenericMap(args)
    local map = {}
    if not self.params then
        return map
    end
    for i, param in ipairs(self.params) do
        map[param] = args[i]
    end
    return map
end

ls.node.registerView('alias', function(viewer, node)
    ---@cast node Node.Alias
    if node.params then
        return '{}<{}>' % {
            node.aliasName,
            table.concat(ls.util.map(node.params, function (param)
                return viewer:view(param)
            end), ', ')
        }
    else
        return node.aliasName
    end
end)
