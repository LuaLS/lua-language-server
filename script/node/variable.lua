---@class Node.Variable: Node
local M = Class 'Node.Variable'

Extends('Node.Variable', 'Node')

M.kind = 'variable'

M.hideInUnionView = true
---@type Node.Variable?
M.parentVariable = nil

---@alias Node.Key string | number | boolean | Node

---@type Node
M.key = nil

---@param scope Scope
---@param name Node.Key
---@param parent? Node.Variable
function M:__init(scope, name, parent)
    if type(name) == 'table' then
        ---@cast name Node
        self.key = name
    else
        ---@cast name -Node
        self.key = scope.rt.value(name)
    end
    self.scope = scope
    self.parent = parent
end

---@type LinkedTable
M.types = nil

---@param node Node
---@return Node.Variable
function M:addType(node)
    if self.parentVariable then
        self.parentVariable:addType(node)
        return self
    end
    if not self.types then
        self.types = ls.tools.linkedTable.create()
    end
    self.types:pushTail(node)
    self:flushCache()

    return self
end

---@param node Node
---@return Node.Variable
function M:removeType(node)
    if self.parentVariable then
        self.parentVariable:removeType(node)
        return self
    end
    if not self.types then
        return self
    end
    self.types:pop(node)
    if self.types:getSize() == 0 then
        self.types = nil
    end
    self:flushCache()

    return self
end

---@type LinkedTable
M.assigns = nil

---@param field Node.Field
---@return Node.Variable
function M:addAssign(field)
    if self.parentVariable then
        self.parentVariable:addAssign(field)
        return self
    end
    if not self.assigns then
        self.assigns = ls.tools.linkedTable.create()
    end
    self.assigns:pushTail(field)

    self:flushCache()

    return self
end

---@param field Node.Field
---@return Node.Variable
function M:removeAssign(field)
    if self.parentVariable then
        self.parentVariable:removeAssign(field)
        return self
    end
    if not self.assigns then
        return self
    end
    self.assigns:pop(field)

    if self.assigns:getSize() == 0 then
        self.assigns = nil

        local parent = self.parent
        for _ = 1, 100 do
            if not parent then
                break
            end
            parent.childs[self.key] = nil
            if not next(parent.childs) then
                parent.childs = nil
                parent = parent.parent
            else
                break
            end
        end
    end
    self:flushCache()

    return self
end

---@type LinkedTable
M.classes = nil

---@param node Node.Class
---@return Node.Variable
function M:addClass(node)
    if self.parentVariable then
        self.parentVariable:addClass(node)
        return self
    end
    if not self.classes then
        self.classes = ls.tools.linkedTable.create()
    end
    self.classes:pushTail(node)
    self:flushCache()

    return self
end

---@param node Node.Class
---@return Node.Variable
function M:removeClass(node)
    if self.parentVariable then
        self.parentVariable:removeClass(node)
        return self
    end
    if not self.classes then
        return self
    end
    self.classes:pop(node)
    if self.classes:getSize() == 0 then
        self.classes = nil
    end
    self:flushCache()

    return self
end

---@type LinkedTable
M.subVariables = nil

---@param variable Node.Variable
---@return Node.Variable
function M:addSubVariable(variable)
    if self.parentVariable then
        self.parentVariable:addSubVariable(variable)
        return self
    end
    if not self.subVariables then
        self.subVariables = ls.tools.linkedTable.create()
    end
    self.subVariables:pushTail(variable)
    variable.parentVariable = self
    self:flushCache()

    return self
end

---@param variable Node.Variable
---@return Node.Variable
function M:removeSubVariable(variable)
    if self.parentVariable then
        self.parentVariable:removeSubVariable(variable)
        return self
    end
    if not self.subVariables then
        return self
    end
    self.subVariables:pop(variable)
    if self.subVariables:getSize() == 0 then
        self.subVariables = nil
    end
    variable.parentVariable = nil
    self:flushCache()

    return self
end

---@type Node|false
M.classValue = nil

---@param self Node.Variable
---@return Node|false
---@return true
M.__getter.classValue = function (self)
    if self.parentVariable then
        return self.parentVariable.classValue, true
    end
    if not self.classes then
        return false, true
    end
    local rt = self.scope.rt
    local union = rt.union(ls.util.map(self.classes:toArray(), function (v)
        ---@cast v Node.Class
        return v.masterType
    end))
    return union, true
end

---@type Node|false
M.typeValue = nil

---@param self Node.Variable
---@return Node|false
---@return true
M.__getter.typeValue = function (self)
    if self.parentVariable then
        return self.parentVariable.typeValue, true
    end
    if not self.types then
        return false, true
    end
    local rt = self.scope.rt
    local union = rt.union(self.types:toArray())
    return union, true
end

---@type Node|false
M.assignValue = nil

---@param self Node.Variable
---@return Node|false
---@return true
M.__getter.assignValue = function (self)
    if self.parentVariable then
        return self.parentVariable.assignValue, true
    end
    if not self.assigns then
        return false, true
    end
    local rt = self.scope.rt
    local union = rt.union(ls.util.map(self.assigns:toArray(), function (v)
        ---@cast v Node.Field
        return v.value
    end))
    return union, true
end

---@type Node|false
M.parentExpectValue = nil

---@param self Node.Variable
---@return Node|false
---@return true?
M.__getter.parentExpectValue = function (self)
    if self.parentVariable then
        return self.parentVariable.parentExpectValue
    end
    local parent = self.parent
    if not parent then
        return false, true
    end
    return parent:getExpect(self.key) or false, true
end

---@type Node.Table
M.fields = nil

---@param self Node.Variable
---@return Node.Table
---@return true
M.__getter.fields = function (self)
    if self.parentVariable then
        return self.parentVariable.fields, true
    end
    local selfValue = self.selfValue
    if selfValue.kind == 'table' then
        ---@cast selfValue Node.Table
        return selfValue, true
    end
    local rt = self.scope.rt
    if selfValue.kind == 'union' then
        ---@cast selfValue Node.Union
        if #selfValue.values == 0 then
            return rt.table(), true
        end
    end
    local table = rt.table()
    local childs = {}
    for t in selfValue:each 'table' do
        ---@cast t Node.Table
        childs[#childs+1] = t
    end
    table:addChilds(childs)
    return table, true
end

---@type table<Node, Node.Variable>?
M.childs = nil

---@param key1 Node.Key
---@param key2? Node.Key
---@param ... Node.Key
---@return Node.Variable
function M:getChild(key1, key2, ...)
    if self.parentVariable then
        return self.parentVariable:getChild(key1, key2, ...)
    end
    local rt = self.scope.rt
    local key = key1
    local path
    if key2 then
        path = { key1, key2, ... }
        key = path[#path]
        path[#path] = nil
    end
    local current = self
    if path then
        for _, k in ipairs(path) do
            if type(k) ~= 'table' then
                ---@cast k -Node
                k = rt.value(k)
            end
            local child = current.childs and current.childs[k]
            if not child then
                child = rt.variable(k, current)
                current.childs = current.childs or {}
                current.childs[k] = child
            end
            current = child
        end
    end
    if type(key) ~= 'table' then
        ---@cast key -Node
        key = rt.value(key)
    end
    local child = current.childs and current.childs[key]
    if not child then
        child = rt.variable(key, current)
        current.childs = current.childs or {}
        current.childs[key] = child
    end
    return child
end

---@param field Node.Field
---@param path? Node.Key[]
---@return Node.Variable
function M:addField(field, path)
    if self.parentVariable then
        self.parentVariable:addField(field, path)
        return self
    end
    local rt = self.scope.rt
    local current = self
    if not current.childs then
        current.childs = {}
    end

    if path then
        for _, k in ipairs(path) do
            if type(k) ~= 'table' then
                ---@cast k -Node
                k = rt.value(k)
            end
            if not current.childs[k] then
                current.childs[k] = rt.variable(k, current)
            end
            current = current.childs[k]
            if not current.childs then
                current.childs = {}
            end
        end
    end

    if not current.childs[field.key] then
        current.childs[field.key] = rt.variable(field.key, current)
    end
    current = current.childs[field.key]
    if field.value then
        current:addAssign(field)
    end
    current.parent:flushCache()

    return current
end

---@param key string|number|boolean|Node
---@return Node
function M:get(key)
    if self.parentVariable then
        return self.parentVariable:get(key)
    end
    local rt = self.scope.rt
    if type(key) ~= 'table' then
        ---@cast key -Node
        key = rt.value(key)
    end
    return self.value:get(key)
end

---@param key string|number|boolean|Node
---@return Node?
function M:getExpect(key)
    if self.parentVariable then
        return self.parentVariable:getExpect(key)
    end
    if self.parentExpectValue then
        return self.parentExpectValue:get(key)
    end
    local rt = self.scope.rt
    if self.classes then
        local expectValue = rt.union(ls.util.map(self.classes:toArray(), function (v)
            ---@cast v Node.Class
            return v.masterType.expectValue
        end))
        return expectValue:get(key)
    end
    if self.types then
        local expectValue = rt.union(ls.util.map(self.types:toArray(), function (v)
            ---@cast v Node.Type
            return v.expectValue
        end))
        return expectValue:get(key)
    end
    return nil
end

---@param key Node.Key
---@param variable Node.Variable
---@return Node.Variable
function M:setChild(key, variable)
    if self.parentVariable then
        self.parentVariable:setChild(key, variable)
        return self
    end
    if type(key) ~= 'table' then
        ---@cast key -Node
        key = self.scope.rt.value(key)
    end
    if not self.childs then
        self.childs = {}
    end
    self.childs[key] = variable
    self:flushCache()
    return self
end

---@param field Node.Field
---@param path? Node.Key[]
---@return Node.Variable
function M:removeField(field, path)
    if self.parentVariable then
        self.parentVariable:removeField(field, path)
        return self
    end
    if not self.childs then
        return self
    end
    ---@type Node.Variable
    local current = self
    if not current.childs then
        return self
    end

    local rt = self.scope.rt
    if path then
        for _, k in ipairs(path) do
            if type(k) ~= 'table' then
                ---@cast k -Node
                k = rt.value(k)
            end
            ---@type Node.Variable
            current = current.childs[k]
            if not current or not current.childs then
                return self
            end
        end
    end

    current = current.childs[field.key]
    if not current then
        return self
    end
    current:removeAssign(field)
    current.parent:flushCache()

    return current
end

---@type Node
M.value = nil

---@param self Node.Variable
---@return Node
---@return true
M.__getter.value = function (self)
    if self.parentVariable then
        return self.parentVariable.value, true
    end
    local rt = self.scope.rt
    return self.parentExpectValue
        or self.classValue
        or self.typeValue
        or self.selfValue
        or rt.UNKNOWN
        , true
end

---@type Node
M.selfValue = nil

---@param self Node.Variable
---@return Node
---@return true
M.__getter.selfValue = function (self)
    if self.parentVariable then
        return self.parentVariable.selfValue, true
    end
    local rt = self.scope.rt
    ---@type Node?
    local result = nil
    if self.assignValue then
        result = self.assignValue
    end
    if self.childs then
        result = result | self.childsValue
    end

    return result or rt.UNKNOWN, true
end

---@type Node.Table
M.childsValue = nil

---@param self Node.Variable
---@return Node.Table
---@return true
M.__getter.childsValue = function (self)
    if self.parentVariable then
        return self.parentVariable.childsValue, true
    end
    local rt = self.scope.rt
    local table = rt.table()
    if not self.childs then
        return table, true
    end
    for key, var in pairs(self.childs) do
        table:addField {
            key   = key,
            value = var,
        }
    end
    return table, true
end

---@private
M._hideAtHead = false

---@return Node.Variable
function M:hideAtHead()
    self._hideAtHead = true
    return self
end

---@param viewer Node.Viewer
---@param options Node.Viewer.Options
---@return string
function M:onViewAsVariable(viewer, options)
    ---@type Node.Variable[]
    local path = {}
    local current = self
    local tooLong
    while current do
        path[#path+1] = current
        current = current.parent
        if #path >= 8 then
            tooLong = true
            break
        end
    end
    if not tooLong then
        for i = #path, 2, -1 do
            local var = path[i]
            if var._hideAtHead then
                path[i] = nil
            else
                break
            end
        end
    end

    local views = {}
    if tooLong then
        views[#views+1] = '...'
    end
    views[#views+1] = viewer:viewAsKey(path[#path].key, {
        skipLevel = options.skipLevel,
    })
    for i = #path - 1, 1, -1 do
        local var = path[i]
        local view = viewer:viewAsKey(var.key, {
            skipLevel = options.skipLevel,
        })
        if view:sub(1, 1) ~= '[' then
            view = '.' .. view
        end
        views[#views+1] = view
    end

    return table.concat(views)
end

---@param other Node
---@return boolean
function M:onCanBeCast(other)
    return other:canCast(self.value)
end

---@param other Node
---@return boolean
function M:onCanCast(other)
    return self.value:canCast(other)
end
