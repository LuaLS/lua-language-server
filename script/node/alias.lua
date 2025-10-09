---@class Node.Alias: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
local M = ls.node.register 'Node.Alias'

M.kind = 'alias'

---@param scope Scope
---@param name string
---@param params? Node.Generic[]
---@param extends? Node[]
function M:__init(scope, name, params, extends)
    self.aliasName = name
    self.scope = scope
    self.params = params
    self.extends = extends
end

---@type Node.Location?
M.location = nil

---@param location Node.Location
function M:setLocation(location)
    self.location = location
end

function M:view(skipLevel)
    if self.params then
        return '{}<{}>' % {
            self.aliasName,
            table.concat(ls.util.map(self.params, function (param)
                return param:view(skipLevel)
            end), ', '),
        }
    else
        return self.aliasName
    end
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
