---@class Node.Table: Node
---@operator bor(Node?): Node
---@overload fun(): Node.Table
local M = ls.node.register 'Node.Table'

M.kind = 'table'

function M:__init()
    ---@private
    ---@type { [string]: Node }
    self.sfields = {}
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
        if key.valueType == 'string' then
            self.sfields[k] = value | self.sfields[k]
            return self
        end
    end

    table.insert(self.nfields, { key = key, value = value })
    return self
end

function M:view(skipLevel)
    local fields = {}

    for k, v in pairs(self.sfields) do
        fields[#fields+1] = string.format('%s: %s'
            , k
            , v:view(skipLevel)
        )
    end
    table.sort(fields)

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
