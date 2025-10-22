---@class Node.Viewer
local M = Class 'Node.Viewer'

M.onViewMap = {}
M.onViewAsKeyMap = {}

---@param skipLevel integer?
function M:__init(skipLevel)
    ---@type integer
    self.skipLevel = skipLevel or 0
    ---@type table<Node, integer?>
    self.visited = {}
end

---@param node Node
---@param deltaLevel integer?
---@param needParentheses boolean?
---@return string
function M:view(node, deltaLevel, needParentheses)
    if not deltaLevel then
        deltaLevel = 1
    end
    self.skipLevel = self.skipLevel + deltaLevel
    local result = self:onView(node, needParentheses)
    return result
end

---@param node Node
---@return string
function M:viewAsKey(node)
    local result = self:onViewAsKey(node)
    if result then
        return result
    end
    return '[' .. self:view(node) .. ']'
end

---@param node Node.Generic
---@return string
function M:viewAsParam(node)
    local buf = {}
    buf[#buf+1] = node.name
    if node.extends ~= node.scope.node.ANY then
        buf[#buf+1] = ':'
        buf[#buf+1] = self:view(node.extends, 0)
    end
    if node.default then
        buf[#buf+1] = '='
        buf[#buf+1] = self:view(node.default, 0)
    end
    return table.concat(buf)
end

---@param fmt string
---@param node Node
---@param delta integer?
---@param needParentheses boolean?
---@return string
function M:format(fmt, node, delta, needParentheses)
    return string.format(fmt, self:view(node, delta, needParentheses))
end

---@private
---@param node Node
---@param needParentheses boolean?
---@return string
function M:onView(node, needParentheses)
    local callback = M.onViewMap[node.kind]
    if callback then
        self.visited[node] = (self.visited[node] or 0) + 1
        local result = callback(self, node, needParentheses)
        self.visited[node] = self.visited[node] - 1
        return result
    end
    local value = node.value
    if value == node then
        error('Cannot view node of kind ' .. node.kind)
    end
    return self:onView(value, needParentheses)
end

---@private
---@param node Node
---@return string?
function M:onViewAsKey(node)
    local callback = M.onViewAsKeyMap[node.kind]
    if callback then
        return callback(self, node)
    end
    local value = node.value
    if value == node then
        return nil
    end
    return self:onViewAsKey(value)
end

---@param kind string
---@param callback fun(viewer: Node.Viewer, node: Node, needParentheses: boolean?):string
function ls.node.registerView(kind, callback)
    M.onViewMap[kind] = callback
end

---@param kind string
---@param callback fun(viewer: Node.Viewer, node: Node):string
function ls.node.registerViewAsKey(kind, callback)
    M.onViewAsKeyMap[kind] = callback
end
