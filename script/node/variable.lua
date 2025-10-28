---@class Node.Variable: Node
local M = Class 'Node.Variable'

Extends('Node.Variable', 'Node')

M.kind = 'variable'

M.hideInUnionView = true
---@type Node.Variable?
M.parentVariable = nil

---@alias Node.Key string | number | boolean | Node

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
M.nodes = nil

---@param node Node
---@return Node.Variable
function M:addType(node)
    if self.parentVariable then
        self.parentVariable:addType(node)
        return self
    end
    if not self.nodes then
        self.nodes = ls.tools.linkedTable.create()
    end
    self.nodes:pushTail(node)
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
    if not self.nodes then
        return self
    end
    self.nodes:pop(node)
    if self.nodes:getSize() == 0 then
        self.nodes = nil
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

    local value = field.value and field.value.solve
    if value and value.kind == 'table' then
        ---@cast value Node.Table
        if value.fields then
            ---@param vfield Node.Field
            for vfield in value.fields:pairsFast() do
                self:addField(vfield)
            end
        end
    end

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

    local value = field.value and field.value.solve
    if value and value.kind == 'table' then
        ---@cast value Node.Table
        if value.fields then
            ---@param vfield Node.Field
            for vfield in value.fields:pairsFast() do
                self:removeField(vfield)
            end
        end
    end

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

---@type Node.Table?
M.fields = nil

---@pacakge
---@param t Node.Table
function M:mergeFields(t)
    local node = self.scope.rt
    for k, v in pairs(self.childs) do
        if type(k) ~= 'table' then
            ---@cast k -Node
            k = node.value(k)
        end
        t:addField {
            key = k,
            value = v.value,
        }
    end
end

---@param self Node.Variable
---@return Node.Table?
---@return boolean
M.__getter.fields = function (self)
    if self.parentVariable then
        return self.parentVariable.fields, false
    end
    if not self.childs then
        return nil, false
    end
    local t = self.scope.rt.table()
    self:mergeFields(t)
    return t, true
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
    local node = self.scope.rt
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
                k = node.value(k)
            end
            local child = current.childs and current.childs[k]
            if not child then
                child = node.variable(k, current)
                current.childs = current.childs or {}
                current.childs[k] = child
            end
            current = child
        end
    end
    if type(key) ~= 'table' then
        ---@cast key -Node
        key = node.value(key)
    end
    local child = current.childs and current.childs[key]
    if not child then
        child = node.variable(key, current)
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
    local node = self.scope.rt
    local current = self
    if not current.childs then
        current.childs = {}
    end

    if path then
        for _, k in ipairs(path) do
            if type(k) ~= 'table' then
                ---@cast k -Node
                k = node.value(k)
            end
            if not current.childs[k] then
                current.childs[k] = node.variable(k, current)
            end
            current = current.childs[k]
            if not current.childs then
                current.childs = {}
            end
        end
    end

    if not current.childs[field.key] then
        current.childs[field.key] = node.variable(field.key, current)
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
    local node = self.scope.rt
    if type(key) ~= 'table' then
        ---@cast key -Node
        key = node.value(key)
    end
    return self.value:get(key)
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

    local node = self.scope.rt
    if path then
        for _, k in ipairs(path) do
            if type(k) ~= 'table' then
                ---@cast k -Node
                k = node.value(k)
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
---@return boolean
M.__getter.value = function (self)
    if self.parentVariable then
        return self.parentVariable.value, false
    end
    local node = self.scope.rt
    if self.classes then
        local union = node.union(ls.util.map(self.classes:toArray(), function (v, k)
            ---@cast v Node.Class
            return node.type(v.className)
        end))
        return union, true
    end
    if self.nodes then
        local union = node.union(self.nodes:toArray())
        return union, true
    end
    if self.assigns then
        local union = node.union(ls.util.map(self.assigns:toArray(), function (v, k)
            return v.value
        end))
        if self.fields then
            return union & self.fields, true
        else
            return union, true
        end
    end
    return self.fields or self.scope.rt.UNKNOWN, true
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
