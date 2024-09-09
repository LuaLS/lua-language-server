---@class Node.Table: Node
---@operator bor(Node?): Node
---@overload fun(): Node.Table
local M = ls.node.register 'Node.Table'

M.kind = 'table'

function M:__init()
    ---@package
    ---@type { [string]: Node }
    self.vfields = {}
    ---@package
    ---@type { key: Node, value: Node }[]
    self.nfields = {}
end

---@param key Node
---@param value Node
---@return Node.Table
function M:insert(key, value)
    if key.kind == 'value' then
        ---@cast key Node.Value
        local k = key.value
        if self.vfields[k] then
            self.vfields[k] = value | self.vfields[k]
        else
            self.vfields[k] = value
            self.values = nil
        end
        return self
    end

    table.insert(self.nfields, { key = key, value = value })
    self.values = nil
    return self
end

---@type { key: Node, value: Node }[]
M.values = nil

---@param self Node.Table
---@return { key: Node, value: Node }[], boolean
M.__getter.values = function (self)
    local values = {}

    local typeOrder = {
        ['number']  = 1,
        ['string']  = 2,
        ['boolean'] = 3,
    }

    for k, v in ls.util.sortPairs(self.vfields, function (a, b)
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
        table.insert(values, { key = ls.node.value(k), value = v })
    end

    for _, v in ipairs(self.nfields) do
        table.insert(values, v)
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
