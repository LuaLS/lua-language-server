---@class Node.Viewer
local M = Class 'Node.Viewer'

---@class Node.Viewer.Options
---@field skipLevel? integer
---@field needParentheses? boolean
---@field noFunctionDetail? boolean
---@field noTableDetail? boolean
---@field preferMethod? boolean
---@field viewType? Node.Type  # 外部视角：传入被观察的类型，隐藏 private 和 protected
---@field viewClass? Node.Type # 子类视角：传入当前所在类，只隐藏从父类继承的 private 字段
---@field inlineMax? integer # 字段数 <= 该值时单行显示，默认为 1
---@field [any] never

---@param options? Node.Viewer.Options
function M:__init(options)
    self.deep = 0
    self.indentation = 0
    ---@type integer
    self.skipLevel        = options and options.skipLevel        or 0
    self.noFunctionDetail = options and options.noFunctionDetail or false
    self.insideTable      = options and options.noTableDetail    or false
    self.preferMethod     = options and options.preferMethod     or false
    self.viewType         = options and options.viewType         or nil
    self.viewClass        = options and options.viewClass        or nil
    self.inlineMax        = options and options.inlineMax        ~= nil and options.inlineMax or 1
    ---@type table<Node, integer?>
    self.visited = {}
end

---@private
---@param node Node
---@param options? Node.Viewer.Options
---@param callback fun(): string
---@return string
function M:wrap(node, options, callback)
    local skipLevel = options and options.skipLevel or 1
    self.skipLevel = self.skipLevel + skipLevel
    self.deep = self.deep + 1
    if self.deep >= 100 then
        self.deep = self.deep - 1
        return '...'
    end
    self.visited[node] = (self.visited[node] or 0) + 1
    local result = callback()
    self.visited[node] = self.visited[node] - 1
    self.deep = self.deep - 1
    self.skipLevel = self.skipLevel - skipLevel
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
function M:viewAsList(node, options)
    return self:wrap(node, options, function ()
        return node:onViewAsList(self, options or {})
    end)
end

---@param fmt string
---@param node Node
---@param options? Node.Viewer.Options
---@return string
function M:format(fmt, node, options)
    return string.format(fmt, self:view(node, options))
end

---@param options? Node.Viewer.Options
---@return Node.Viewer
function ls.node.viewer(options)
    return New 'Node.Viewer' (options)
end
