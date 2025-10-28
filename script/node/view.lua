---@class Node.Viewer
local M = Class 'Node.Viewer'

---@class Node.Viewer.Options
---@field skipLevel? integer
---@field needParentheses? boolean
---@field [any] never

---@param options? Node.Viewer.Options
function M:__init(options)
    ---@type integer
    self.skipLevel = options and options.skipLevel or 0
    self.deep = 0
    ---@type table<Node, integer?>
    self.visited = {}
end

---@private
---@param node Node
---@param options? Node.Viewer.Options
---@param callback fun(): string
---@return string
function M:wrap(node, options, callback)
    self.skipLevel = self.skipLevel + (options and options.skipLevel or 1)
    self.deep = self.deep + 1
    if self.deep >= 100 then
        self.deep = self.deep - 1
        return '...'
    end
    self.visited[node] = (self.visited[node] or 0) + 1
    local result = callback()
    self.visited[node] = self.visited[node] - 1
    self.deep = self.deep - 1
    return result
end

---@param node Node
---@param options? Node.Viewer.Options
---@return string
function M:view(node, options)
    return self:wrap(node, options, function ()
        return node:onView(self, options or {})
    end)
end

---@param node Node
---@param options? Node.Viewer.Options
---@return string
function M:viewAsKey(node, options)
    return self:wrap(node, options, function ()
        return node:onViewAsKey(self, options or {})
    end)
end

---@param node Node
---@param options? Node.Viewer.Options
---@return string
function M:viewAsParam(node, options)
    return self:wrap(node, options, function ()
        return node:onViewAsParam(self, options or {})
    end)
end

---@param node Node
---@param options? Node.Viewer.Options
---@return string
function M:viewAsVariable(node, options)
    return self:wrap(node, options, function ()
        return node:onViewAsVariable(self, options or {})
    end)
end

---@param node Node
---@param options? Node.Viewer.Options
---@return string
function M:viewAsVararg(node, options)
    return self:wrap(node, options, function ()
        return node:onViewAsVararg(self, options or {})
    end)
end

---@param fmt string
---@param node Node
---@param options? Node.Viewer.Options
---@return string
function M:format(fmt, node, options)
    return string.format(fmt, self:view(node, options))
end
