---@class Node.Variable: Class.Base, Node.CacheModule
local M = Class 'Node.Variable'

Extends('Node.Variable', 'Node.CacheModule')

M.kind = 'variable'

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
        self.key = scope.node.value(name)
    end
    self.scope = scope
    self.parent = parent
end

---@type LinkedTable
M.nodes = nil

---@param node Node.Type
---@return Node.Variable
function M:addType(node)
    if not self.nodes then
        self.nodes = ls.linkedTable.create()
    end
    self.nodes:pushTail(node)
    self:flushCache()

    return self
end

---@param node Node.Type
---@return Node.Variable
function M:removeType(node)
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

---@param node Node
---@return Node.Variable
function M:addAssign(node)
    if not self.assigns then
        self.assigns = ls.linkedTable.create()
    end
    self.assigns:pushTail(node)
    self:flushCache()

    return self
end

---@param node Node
---@return Node.Variable
function M:removeAssign(node)
    if not self.assigns then
        return self
    end
    self.assigns:pop(node)
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

---@param node Node.Type
---@return Node.Variable
function M:addClass(node)
    if not self.classes then
        self.classes = ls.linkedTable.create()
    end
    self.classes:pushTail(node)
    self:flushCache()

    return self
end

---@param node Node.Type
---@return Node.Variable
function M:removeClass(node)
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
    if not self.subVariables then
        self.subVariables = ls.linkedTable.create()
    end
    self.subVariables:pushTail(variable)
    self:flushCache()

    return self
end

---@param variable Node.Variable
---@return Node.Variable
function M:removeSubVariable(variable)
    if not self.subVariables then
        return self
    end
    self.subVariables:pop(variable)
    if self.subVariables:getSize() == 0 then
        self.subVariables = nil
    end
    self:flushCache()

    return self
end

---@type Node.Table?
M.fields = nil

---@pacakge
---@param t Node.Table
---@param variable Node.Variable
function M:mergeFields(t, variable)
    local node = self.scope.node
    for k, v in pairs(variable.childs) do
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
    if not self.childs then
        return nil, false
    end
    local t = self.scope.node.table()
    self:mergeFields(t, self)
    local subVariables = self.subVariables
    if subVariables then
        for sub in subVariables:pairsFast() do
            self:mergeFields(t, sub)
        end
    end
    return t, true
end

---@type table<Node, Node.Variable>?
M.childs = nil

---@param key1 Node.Key
---@param key2? Node.Key
---@param ... Node.Key
---@return Node.Variable
function M:getChild(key1, key2, ...)
    local node = self.scope.node
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
            current = current.childs and current.childs[k]
                    or node.variable(k, current)
        end
    end
    if type(key) ~= 'table' then
        ---@cast key -Node
        key = node.value(key)
    end
    local child = current.childs and current.childs[key]
                or node.variable(key, current)
    return child
end

---@param field Node.Field
---@param path? Node.Key[]
---@return Node.Variable
function M:addField(field, path)
    local node = self.scope.node
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
    current:addAssign(field.value)
    current.parent:flushCache()

    return current
end

---@param field Node.Field
---@param path? Node.Key[]
---@return Node.Variable
function M:removeField(field, path)
    if not self.childs then
        return self
    end
    ---@type Node.Variable
    local current = self
    if not current.childs then
        return self
    end

    local node = self.scope.node
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
    current:removeAssign(field.value)
    current.parent:flushCache()

    return current
end

---@type Node
M.value = nil

---@param self Node.Variable
---@return Node
---@return true
M.__getter.value = function (self)
    local node = self.scope.node
    if self.classes then
        local union = node.union(self.classes:toArray())
        return union, true
    end
    if self.nodes then
        local union = node.union(self.nodes:toArray())
        return union, true
    end
    if self.assigns then
        local union = node.union(self.assigns:toArray())
        return union, true
    end
    return self.scope.node.UNKNOWN, true
end

---@private
M._hideAtHead = false

function M:hideAtHead()
    self._hideAtHead = true
    return self
end

---@param skipLevel? integer
---@return string
function M:view(skipLevel)
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
    views[#views+1] = path[#path].key:viewAsKey(skipLevel)
    for i = #path - 1, 1, -1 do
        local var = path[i]
        local view = var.key:viewAsKey(skipLevel)
        if view:sub(1, 1) ~= '[' then
            view = '.' .. view
        end
        views[#views+1] = view
    end

    return table.concat(views)
end
