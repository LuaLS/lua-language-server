---@class Node.Function: Node
---@operator bor(Node?): Node
---@overload fun(): Node.Function
local M = ls.node.register 'Node.Function'

M.kind = 'function'

---@class Node.Function.Param
---@field key string
---@field value Node

---@class Node.Function.Return
---@field key? string
---@field value Node

function M:__init()
    ---@type Node.Function.Param[]
    self.params = {}
    ---@type Node.Function.Return[]
    self.returns = {}
end

---@param key string
---@param value Node
---@return Node.Function
function M:addParam(key, value)
    self.params[#self.params+1] = { key = key, value = value }
    return self
end

---@param key? string
---@param value Node
---@return Node.Function
function M:addReturn(key, value)
    self.returns[#self.returns+1] = { key = key, value = value }
    return self
end

function M:view()
    local params = {}
    for i, v in ipairs(self.params) do
        params[i] = string.format('%s: %s'
            , v.key
            , v.value:view()
        )
    end

    local returns = {}
    for i, v in ipairs(self.returns) do
        returns[i] = v.value:view()
    end

    if #returns > 0 then
        return string.format('fun(%s):%s'
            , table.concat(params, ', ')
            , table.concat(returns, ', ')
        )
    else
        return string.format('fun(%s)'
            , table.concat(params, ', ')
        )
    end
end

function ls.node.func()
    return New 'Node.Function' ()
end
