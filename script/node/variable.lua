---@class Node.Variable: Node.CacheModule, Node.Field
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

---@param node Node
---@return Node.Variable
function M:addNode(node)
    if not self.nodes then
        self.nodes = ls.linkedTable.create()
    end
    self.nodes:pushTail(node)
    self:flushCache()
    return self
end

---@param node Node
---@return Node.Variable
function M:removeNode(node)
    if not self.nodes then
        return self
    end
    self.nodes:pop(node)
    self:flushCache()
    return self
end

---@type Node.Table
M.childs = nil

---@param child Node.Variable
---@return Node.Variable
function M:addChild(child)
    if not self.childs then
        self.childs = self.scope.node.table()
    end
    self.childs:addField(child)
    self:flushCache()
    return self
end

---@param child Node.Variable
---@return Node.Variable
function M:removeChild(child)
    if not self.childs then
        return self
    end
    self.childs:removeField(child)
    self:flushCache()
    return self
end

---@type Node
M.value = nil

---@param self Node.Variable
---@return Node
---@return true
M.__getter.value = function (self)
    if not self.nodes or self.nodes:getSize() == 0 then
        return self.scope.node.UNKNOWN, true
    end
    if self.nodes:getSize() == 1 then
        return self.nodes:getHead(), true
    end
    local union = self.scope.node.union(self.nodes:toArray())
    return union.value, true
end

---@type Node.Table
M.childNode = nil

---@param self Node.Variable
---@return Node.Table
---@return true
M.__getter.childNode = function (self)
    local node = self.scope.node
    local t = node.table()

    return t, true
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
    for i = 1, #path do
        local var = path[i]
        local view = var.key:viewAsKey(skipLevel)
        if i > 1 and view:sub(1, 1) ~= '[' then
            view = '.' .. view
        end
    end

    return table.concat(views)
end
