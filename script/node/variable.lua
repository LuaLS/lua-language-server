---@class Node.Variable: Class.Base, Node.CacheModule
local M = Class 'Node.Variable'

Extends('Node.Variable', 'Node.CacheModule')

M.kind = 'variable'

---@param scope Scope
---@param name string | number | boolean | Node
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
    self:flushCache()

    return self
end

---@type Node.Table?
M.fields = nil

---@param field Node.Field
---@return Node.Variable
function M:addField(field)
    if not self.fields then
        self.fields = self.scope.node.table()
    end
    self.fields:addField(field)
    self:flushCache()

    return self
end

---@param field Node.Field
---@return Node.Variable
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

---@type Node
M.value = nil

---@param self Node.Variable
---@return Node
---@return true
M.__getter.value = function (self)
    local node = self.scope.node
    if self.classes then
        local union = node.union(self.classes:toArray())
        return union.value, true
    end
    if self.nodes then
        local union = node.union(self.nodes:toArray())
        return union.value, true
    end
    return self.scope.node.UNKNOWN, true
end

M.hideInView = false

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
            if var.hideInView then
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
