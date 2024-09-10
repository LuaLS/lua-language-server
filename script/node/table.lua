---@class Node.Table: Node
---@operator bor(Node?): Node
---@overload fun(): Node.Table
local M = ls.node.register 'Node.Table'

M.kind = 'table'

---@class Node.Field
---@field key Node
---@field value Node

function M:__init()
    ---@package
    self._values = ls.linkedTable.create()
end

---@param field Node.Field
---@return self
function M:insert(field)
    self.values = nil
    self.literals = nil

    self._values:pushTail(field)

    return self
end

---@param field Node.Field
---@return self
function M:remove(field)
    self.values = nil
    self.literals = nil

    self._values:pop(field)

    return self
end

---@type table<string|number|boolean, Node>
M.literals = nil

---@param self Node.Table
---@return table<string|number|boolean, Node>
---@return true
M.__getter.literals = function (self)
    local literals = {}

    ---@param field Node.Field
    for field in self._values:pairsFast() do
        local key = field.key
        if key.kind == 'value' then
            ---@cast key Node.Value
            local k = key.value
            literals[k] = literals[k] | field.value
        end
    end

    return literals, true
end

---@type Node.Field[]
M.values = nil

---@param self Node.Table
---@return { key: Node, value: Node }[]
---@return true
M.__getter.values = function (self)
    ---@type { key: Node, value: Node }[]
    local values = {}

    local typeOrder = {
        ['number']  = 1,
        ['string']  = 2,
        ['boolean'] = 3,
    }

    for k, v in ls.util.sortPairs(self.literals, function (a, b)
        local ta = type(a)
        local tb = type(b)
        local sa = typeOrder[ta] or 0
        local sb = typeOrder[tb] or 0
        if sa == sb then
            if ta == 'number' or ta == 'string' then
                return a < b
            else
                return a == true
            end
        else
            return sa < sb
        end
    end) do
        values[#values+1] = { key = ls.node.value(k), value = v }
    end

    ---@param field Node.Field
    for field in self._values:pairsFast() do
        local key = field.key
        if key.kind ~= 'value' then
            values[#values+1] = field
        end
    end

    return values, true
end

function M:view(skipLevel)
    if #self.values == 0 then
        return '{}'
    end

    local fields = {}

    local childSkipLevel = skipLevel and skipLevel + 1 or nil
    for _, v in ipairs(self.values) do
        fields[#fields+1] = string.format('%s: %s'
            , v.key:viewAsKey(childSkipLevel)
            , v.value:view(childSkipLevel)
        )
    end

    return '{ ' .. table.concat(fields, ', ') .. ' }'
end

---@return Node.Table
function ls.node.table()
    return New 'Node.Table' ()
end
