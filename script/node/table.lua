---@class Node.Table: Node
---@operator bor(Node?): Node
---@overload fun(): Node.Table
local M = ls.node.register 'Node.Table'

M.kind = 'table'

function M:__init()
    ---@private
    ---@type { [string]: Node }
    self.vfields = {}
    ---@private
    ---@type { key: Node, value: Node }[]
    self.nfields = {}
end

---@param key Node.Value
---@param value Node
---@return Node.Table
function M:insert(key, value)
    if key.kind == 'value' then
        ---@cast key Node.Value
        local k = key.value
        self.vfields[k] = value | self.vfields[k]
        return self
    end

    table.insert(self.nfields, { key = key, value = value })
    return self
end

function M:view(skipLevel)
    local fields = {}

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
        if type(k) == 'string' then
            fields[#fields+1] = string.format('%s: %s'
                , k
                , v:view(skipLevel)
            )
        else
            fields[#fields+1] = string.format('[%s]: %s'
                , k
                , v:view(skipLevel)
            )
        end
    end

    for _, v in ipairs(self.nfields) do
        fields[#fields+1] = string.format('[%s]: %s'
            , v.key:view(skipLevel)
            , v.value:view(skipLevel)
        )
    end

    if #fields == 0 then
        return '{}'
    else
        return '{ ' .. table.concat(fields, ', ') .. ' }'
    end
end

---@return Node.Table
function ls.node.table()
    return New 'Node.Table' ()
end
