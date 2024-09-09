---@class Node.Table: Node
---@operator bor(Node?): Node
---@overload fun(): Node.Table
local M = ls.node.register 'Node.Table'

M.cate = 'table'

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
function M:insert(key, value)
    if key.cate == 'value' then
        ---@cast key Node.Value
        local k = key.value
        if key.valueType == 'string' then
            self.sfields[k] = value | self.sfields[k]
            return
        end
    end

    table.insert(self.nfields, { key = key, value = value })
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

function ls.node.table()
    return New 'Node.Table' ()
end
