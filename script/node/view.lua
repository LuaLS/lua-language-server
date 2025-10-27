---@class Node.Viewer
local M = Class 'Node.Viewer'

---@param skipLevel integer?
function M:__init(skipLevel)
    ---@type integer
    self.skipLevel = skipLevel or 0
    self.deep = 0
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
    self.deep = self.deep + 1
    if self.deep >= 10 then
        self.deep = self.deep - 1
        return '...'
    end
    local result = self:onView(node, needParentheses)
    self.deep = self.deep - 1
    return result
end

---@param node Node
---@return string
function M:viewAsKey(node)
    return node:onViewAsKey(self)
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
    self.visited[node] = (self.visited[node] or 0) + 1
    local result = node:onView(self, needParentheses)
    self.visited[node] = self.visited[node] - 1
    return result
end
