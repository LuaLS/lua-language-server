---@class Node.Variable: Class.Base, Node.Field
local M = Class 'Node.Variable'

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
function M:addNode(node)
    if not self.nodes then
        self.nodes = ls.linkedTable.create()
    end
    self.nodes:pushTail(node)
    return self
end

---@param node Node.Type
---@return Node.Variable
function M:removeNode(node)
    if not self.nodes then
        return self
    end
    self.nodes:pop(node)
    return self
end

---@type LinkedTable?
M.fields = nil

---@param child Node.Variable
---@return Node.Variable
function M:addField(child)
    if not self.fields then
        self.fields = ls.linkedTable.create()
    end
    self.fields:pushAfter(child)

    ---@param node Node.Type
    for node in child.nodes:pairsFast() do
        node:addVariableField(child)
    end

    return self
end

---@param child Node.Variable
---@return Node.Variable
function M:removeField(child)
    if not self.fields then
        return self
    end
    self.fields:pop(child)

    ---@param node Node.Type
    for node in child.nodes:pairsFast() do
        node:removeVariableField(child)
    end

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
