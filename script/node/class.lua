---@class Node.Class: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
local M = ls.node.register 'Node.Class'

M.kind = 'class'

---@alias Node.Class.ExtendAble Node.Type | Node.Call | Node.Table

---@param scope Scope
---@param name string
---@param params? Node.Generic[]
---@param extends? Node.Class.ExtendAble[]
function M:__init(scope, name, params, extends)
    self.className = name
    self.scope = scope
    self.params = params
    self.extends = extends

    self.masterType = scope.node.type(name)
    self.masterType:addClass(self)
end

function M:__del()
    self.masterType:removeClass(self)
end

function M:dispose()
    Delete(self)
end

---@param param Node.Generic
---@return Node.Class
function M:addTypeParam(param)
    if not self.params then
        self.params = {}
    end
    table.insert(self.params, param)
    return self
end

---@param extends Node
---@return Node.Class
function M:addExtends(extends)
    if not self.extends then
        self.extends = {}
    end
    table.insert(self.extends, extends)
    self:flushCache()
    for _, v in ipairs(self.extends) do
        v:registerFlushChain(self)
    end
    return self
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

    variable:registerFlushChain(self)
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

    variable:unregisterFlushChain(self)
    self:flushCache()

    return self
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

function M:onView(viewer, needParentheses)
    if self.params then
        return '{}<{}>' % {
            self.className,
            table.concat(ls.util.map(self.params, function (param)
                return viewer:view(param)
            end), ', ')
        }
    else
        return self.className
    end
end
