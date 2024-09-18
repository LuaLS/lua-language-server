---@class Node.Table: Node
---@operator bor(Node?): Node
---@operator shr(Node): boolean
---@overload fun(): Node.Table
local M = ls.node.register 'Node.Table'

M.kind = 'table'

---@class Node.Field
---@field key Node
---@field value Node

function M:__init()
    self.fields = ls.linkedTable.create()
end

---@param field Node.Field
---@return self
function M:addField(field)
    self.sortedFields = nil
    self.literals = nil
    self.types = nil

    self.fields:pushTail(field)

    return self
end

---@param field Node.Field
---@return self
function M:removeField(field)
    self.sortedFields = nil
    self.literals = nil
    self.types = nil

    self.fields:pop(field)

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
    for field in self.fields:pairsFast() do
        local key = field.key
        if key.kind == 'value' then
            ---@cast key Node.Value
            local k = key.value
            literals[k] = literals[k] | field.value
        end
        if key.kind == 'union' then
            ---@cast key Node.Union
            for _, v in ipairs(key.values) do
                if v.kind == 'value' then
                    ---@cast v Node.Value
                    local k = v.value
                    literals[k] = literals[k] | field.value
                end
            end
        end
    end

    return literals, true
end

---@type table<string, Node>
M.types = nil

---@param self Node.Table
---@return table<string, Node>
---@return true
M.__getter.types = function (self)
    local types = {}

    ---@param field Node.Field
    for field in self.fields:pairsFast() do
        local key = field.key
        if key.kind ~= 'value' and key.typeName then
            types[key.typeName] = types[key.typeName] | field.value
        end
        if key.kind == 'union' then
            ---@cast key Node.Union
            for _, v in ipairs(key.values) do
                if v.kind ~= 'value' and v.typeName then
                    types[v.typeName] = types[v.typeName] | field.value
                end
            end
        end
    end

    return types, true
end

---获取所有的键。没有进行去重或排序。
---@type Node[]
M.tableKeys = nil

---@param self Node.Table
---@return Node[]
---@return true
M.__getter.tableKeys = function (self)
    local keys = {}

    ---@param field Node.Field
    for field in self.fields:pairsFast() do
        keys[#keys+1] = field.key
    end

    return keys, true
end

---获取所有的值。没有进行去重或排序。
---@type Node[]
M.tableValues = nil

---@param self Node.Table
---@return Node[]
---@return true
M.__getter.tableValues = function (self)
    local values = {}

    ---@param field Node.Field
    for field in self.fields:pairsFast() do
        values[#values+1] = field.value
    end

    return values, true
end

---@type Node.Field[]
M.sortedFields = nil

---@param self Node.Table
---@return { key: Node, value: Node }[]
---@return true
M.__getter.sortedFields = function (self)
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

    for k, v in ls.util.sortPairs(self.types) do
        values[#values+1] = { key = ls.node.value(k), value = v }
    end

    return values, true
end

---@param key string|number|boolean|Node
---@return Node
function M:get(key)
    local tp = type(key)
    if tp ~= 'table' then
        ---@cast key -Node
        return self.literals[key] or self:get(ls.node.value(key))
    end
    if key == ls.node.ANY then
        return ls.node.union(self.tableValues):simplify() or ls.node.ANY
    end
    if key == ls.node.UNKNOWN then
        return ls.node.union(self.tableValues):simplify() or ls.node.NIL
    end
    ---@cast key Node
    if key.typeName then
        return self.types[key.typeName] or ls.node.NIL
    end
    if key.kind == 'union' then
        local result
        ---@cast key Node.Union
        for _, v in ipairs(key.values) do
            local r = self:get(v) or ls.node.NIL
            result = result | r
        end
        return result or ls.node.NIL
    end
    return ls.node.NIL
end

function M:view(skipLevel)
    if #self.sortedFields == 0 then
        return '{}'
    end

    local fields = {}

    local childSkipLevel = skipLevel and skipLevel + 1 or nil
    for _, v in ipairs(self.sortedFields) do
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
