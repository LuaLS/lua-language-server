---@class Node.Type: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(name: string): Node.Type
local M = ls.node.register 'Node.Type'

M.kind = 'type'

---@param name string
function M:__init(name)
    self.typeName = name
end

---@param field Node.Field
---@return self
function M:addField(field)
    if not self.table then
        self.table = ls.node.table()
    end
    self.table:addField(field)
    self:refreshFieldCache()
    return self
end

---@param field Node.Field
---@return self
function M:removeField(field)
    if not self.table then
        return self
    end
    self.table:removeField(field)
    self:refreshFieldCache()
    return self
end

---@package
function M:refreshFieldCache()
    self.sortedFields  = nil
    self.tableKeys     = nil
    self.tableValues   = nil
    self.tableLiterals = nil
    self.tableTypes    = nil
end

---获取所有的键。
---@type Node[]
M.tableKeys = nil

---@param self Node.Table
---@return Node[]
---@return true
M.__getter.tableKeys = function (self)
    local keys = {}

    for _, field in ipairs(self.sortedFields) do
        keys[#keys+1] = field.key
    end

    return keys, true
end

---获取所有的值。按key的顺序排序。
---@type Node[]
M.tableValues = nil

---@param self Node.Type
---@return Node[]
---@return true
M.__getter.tableValues = function (self)
    local values = {}

    for _, field in ipairs(self.sortedFields) do
        values[#values+1] = field.value
    end

    return values, true
end

---@type table<string|number|boolean, Node>
M.tableLiterals = nil

---@param self Node.Type
---@return table<string|number|boolean, Node>
---@return true
M.__getter.tableLiterals = function (self)
    local literals = {}

    for _, t in ipairs(self.fullTables) do
        for k, v in pairs(t.literals) do
            if literals[k] == nil then
                literals[k] = v
            end
        end
    end

    return literals, true
end

---@type table<string, Node>
M.tableTypes = nil

---@param self Node.Type
---@return table<string, Node>
---@return true
M.__getter.tableTypes = function (self)
    local types = {}

    for _, t in ipairs(self.fullTables) do
        for k, v in pairs(t.types) do
            if types[k] == nil then
                types[k] = v
            end
        end
    end

    return types, true
end

---@type Node.Field[]
M.sortedFields = nil

---@param self Node.Type
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

    for k, v in ls.util.sortPairs(self.tableLiterals, function (a, b)
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

    for k, v in ls.util.sortPairs(self.tableTypes) do
        values[#values+1] = { key = ls.node.type(k), value = v }
    end

    return values, true
end

---@param key string|number|boolean|Node
---@param dontLookup? boolean
---@return Node
function M:get(key, dontLookup)
    if not self.extends and not self.table then
        return ls.node.NEVER
    end
    if key == ls.node.ANY then
        return ls.node.union(self.tableValues):simplify() or ls.node.ANY
    end
    if key == ls.node.UNKNOWN then
        return ls.node.union(self.tableValues):simplify() or ls.node.NIL
    end
    if key == ls.node.NIL then
        return ls.node.NIL
    end
    local res = self.table:get(key)
    if res ~= ls.node.NIL then
        return res
    end
    if dontLookup then
        return ls.node.NIL
    end
    for _, v in ipairs(self.fullTables) do
        res = v:get(key)
        if res ~= ls.node.NIL then
            return res
        end
    end
    return ls.node.NIL
end

---@param extends Node.Type | Node.Table
---@return self
function M:addExtends(extends)
    if not self.extends then
        self.extends = ls.linkedTable.create()
    end
    self.extends:pushTail(extends)

    self.fullExtends = nil
    self.fullTables  = nil
    self:refreshFieldCache()
    return self
end

---@param extends Node
---@return self
function M:removeExtends(extends)
    if not self.extends then
        return self
    end
    self.extends:pop(extends)

    self.fullExtends = nil
    self.fullTables  = nil
    self:refreshFieldCache()
    return self
end

---@type Node[]
M.fullExtends = nil

---获取所有继承（广度优先）
---@param self Node.Type
---@return Node[]
---@return true
M.__getter.fullExtends = function (self)
    local result = {}
    local mark = {}

    ---@param t Node.Type
    ---@param nextQueue Node.Type[]
    local function pushExtends(t, nextQueue)
        if not t.extends then
            return
        end
        ---@param v Node
        for v in t.extends:pairsFast() do
            if mark[v] then
                goto continue
            end
            mark[v] = true
            result[#result+1] = v
            if v.kind == 'type' then
                nextQueue[#nextQueue+1] = v
            end
            ::continue::
        end
    end

    ---@param queue Node.Type[]
    local function search(queue)
        local nextQueue = {}
        for _, v in ipairs(queue) do
            pushExtends(v, nextQueue)
        end
        if #nextQueue == 0 then
            return
        end
        search(nextQueue)
    end

    search { self }

    return result, true
end

---@type Node.Table[]
M.fullTables = nil

---获取所有继承的表（广度优先）
---@param self Node.Type
---@return Node.Table[]
---@return true
M.__getter.fullTables = function (self)
    ---@type Node.Table[]
    local tables = { self.table }

    for _, v in ipairs(self.fullExtends) do
        if v.kind == 'table' then
            ---@cast v Node.Table
            tables[#tables+1] = v
        elseif v.kind == 'type' then
            ---@cast v Node.Type
            tables[#tables+1] = v.table
        end
    end

    return tables, true
end

function M:view()
    return self.typeName
end

---@type fun(self: Node.Type, other: Node): boolean?
M._onCanCast = nil

---@type fun(self: Node.Type, other: Node): boolean?
M._onCanBeCast = nil

---@overload fun(self, key: 'onCanCast', value: fun(self: Node.Type, other: Node): boolean?): Node.Type
---@overload fun(self, key: 'onCanBeCast', value: fun(self: Node.Type, other: Node): boolean?): Node.Type
function M:setConfig(key, value)
    self['_' .. key] = value
    return self
end

---@param other Node
---@return boolean?
function M:onCanBeCast(other)
    if other.typeName == 'never' then
        return false
    end
    if self._onCanBeCast then
        ---@cast other Node.Type
        local res = self._onCanBeCast(self, other)
        if res ~= nil then
            return res
        end
    end
end

---@param other Node
---@return boolean
function M:onCanCast(other)
    if other.typeName == 'never' then
        return false
    end
    if self._onCanCast then
        local res = self._onCanCast(self, other)
        if res then
            return res
        end
    end
    if other.kind == 'type' then
        ---@cast other Node.Type
        if self.typeName == other.typeName then
            return true
        end
        for _, v in ipairs(self.fullExtends) do
            if v.kind == 'type' then
                ---@cast v Node.Type
                if v.typeName == other.typeName then
                    return true
                end
                if v._onCanCast then
                    local res = v._onCanCast(v, other)
                    if res then
                        return res
                    end
                end
            end
        end
    end
    if other.kind == 'table' then
        ---@cast other Node.Table | Node.Type
        for _, field in ipairs(other.sortedFields) do
            local v = self:get(field.key) or ls.node.NIL
            if not v:canCast(field.value) then
                return false
            end
        end
        return true
    end
    return false
end

---@type { never: nil, [string]: Node.Type}
ls.node.TYPE = setmetatable({}, {
    __mode = 'v',
    __index = function (t, k)
        local v = New 'Node.Type' (k)
        t[k] = v
        return v
    end,
})

---@overload fun(name: 'never'): Node
---@overload fun(name: string): Node.Type
function ls.node.type(name)
    return ls.node.TYPE[name]
end
