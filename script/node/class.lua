---@class Node.Class: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
local M = ls.node.register 'Node.Class'

M.kind = 'class'

---@param scope Scope
---@param name string
---@param params? Node.Generic[]
---@param extends? Node[]
function M:__init(scope, name, params, extends)
    self.className = name
    self.scope = scope
    self.params = params
    self.extends = extends
end

--- 所有使用 ---@field 定义的字段
---@type Node.Table?
M.fields = nil

--- 添加字段（使用 ---@field 定义的字段）
---@param field Node.Field
---@return Node.Class
function M:addField(field)
    if not self.fields then
        self.fields = self.scope.node.table()
    end
    self.fields:addField(field)
    self:flushCache()
    return self
end

---@param field Node.Field
---@return Node.Class
function M:removeField(field)
    if not self.fields then
        return self
    end
    self.fields:removeField(field)
    if self.fields:isEmpty() then
        self.fields = nil
    end
    self:flushCache()
    return self
end

---@type Node.Location?
M.location = nil

---@param location Node.Location
function M:setLocation(location)
    self.location = location
end

--- 添加绑定的变量
---@param variable Node.Variable
---@return Node.Class
function M:addVariable(variable)
    if not self.variables then
        self.variables = ls.linkedTable.create()
    end

    self.variables:pushTail(variable)

    variable:flushMe(self, true)
    self:flushCache()

    return self
end

--- 所有绑定的变量
---@type LinkedTable?
M.variables = nil

---@param variable Node.Variable
---@return Node.Class
function M:removeVariable(variable)
    if not self.variables then
        return self
    end
    self.variables:pop(variable)
    if self.variables:getSize() == 0 then
        self.variables = nil
    end

    variable:flushMe(self, false)
    self:flushCache()

    return self
end

function M:view(skipLevel)
    if self.params then
        return '{}<{}>' % {
            self.className,
            table.concat(ls.util.map(self.params, function (param)
                return param:view(skipLevel)
            end), ', '),
        }
    else
        return self.className
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
