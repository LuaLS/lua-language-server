---@class Node.Table: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(scope: Scope, fields?: table): Node.Table
local M = ls.node.register 'Node.Table'

M.kind = 'table'

---@type LinkedTable?
M.fields = nil

---@param scope Scope
---@param fields? table
function M:__init(scope, fields)
    self.scope = scope
    if fields and next(fields) then
        self.fields = ls.tools.linkedTable.create()
        for k, v in pairs(fields) do
            if type(v) ~= 'table' then
                v = scope.rt.value(v)
            end
            self.fields:pushTail(scope.rt.field(k, v))
        end
    end
end

---@param field Node.Field
---@return Node.Table
function M:addField(field)
    if not self.fields then
        self.fields = ls.tools.linkedTable.create()
    end
    self.fields:pushTail(field)
    self:flushCache()
    return self
end

---@param field Node.Field
---@return Node.Table
function M:removeField(field)
    if not self.fields then
        return self
    end
    self.fields:pop(field)
    self:flushCache()
    return self
end

function M:isEmpty()
    if not self.fields then
        return true
    end
    return self.fields:getSize() == 0
end

---@type Node.Location[]?
M.locations = nil

---@param location Node.Location
function M:addLocation(location)
    if not self.locations then
        self.locations = {}
    end
    self.locations[#self.locations+1] = location
end

---@type table<Node, Node.Field|Node.Field[]>
M.fieldMap = nil

---@param self Node.Table
---@return table<Node, Node.Field|Node.Field[]>
---@return true
M.__getter.fieldMap = function (self)
    local fieldMap = {}

    if not self.fields then
        return fieldMap, true
    end

    local rt = self.scope.rt

    ---@param field Node.Field
    for field in self.fields:pairsFast() do
        local key = field.key:simplify()
        key:addRef(self)
        if field.value then
            field.value:addRef(self)
        end
        if key.kind == 'union' then
            ---@cast key Node.Union
            for _, k in ipairs(key.values) do
                k = rt.nodeKey(k)
                fieldMap[k] = field
            end
        else
            key = rt.nodeKey(key)
            fieldMap[key] = field
        end
    end

    return fieldMap, true
end

---获取所有的键。
---@type Node[]
M.keys = nil

---@param self Node.Table
---@return Node[]
---@return true
M.__getter.keys = function (self)
    ---@type Node[]
    local keys = {}

    for k in pairs(self.fieldMap) do
        keys[#keys+1] = k
    end

    local typeOrder = {
        ['number']  = 1,
        ['string']  = 2,
        ['boolean'] = 3,
    }

    ls.util.sort(keys, function (a, b)
        local isValueA = a.kind == 'value'
        local isValueB = b.kind == 'value'
        if isValueA == isValueB then
            return nil
        end
        if isValueA then
            return true
        else
            return false
        end
    end, function (a, b)
        if a.kind == 'value' then
            local va = a.literal
            local vb = b.literal
            if va == vb then
                return
            end
            local ta = type(va)
            local tb = type(vb)
            if ta ~= tb then
                return typeOrder[ta] < typeOrder[tb]
            end
            if ta == 'string' then
                ---@cast vb string
                return ls.util.stringLess(va, vb)
            end
            if ta == 'number' then
                return va < vb
            end
            if ta == 'boolean' then
                return (va == true) and (vb == false)
            end
        else
            return a.typeName < b.typeName
        end
    end)

    return keys, true
end

---@param self Node.Table
---@return Node
---@return true
M.__getter.typeOfKey = function (self)
    return self.scope.rt.union(self.keys), true
end

---@type table<Node.Key, Node.Field>
M.valueMap = nil

---@param self Node.Table
---@return table<Node.Key, Node.Field>
---@return true
M.__getter.valueMap = function (self)
    local rt = self.scope.rt
    local valueMap = {}
    for k, field in pairs(self.fieldMap) do
        if #field > 0 then
            ls.util.arrayMerge(valueMap[rt.luaKey(k)], field)
        else
            valueMap[rt.luaKey(k)] = field
        end
    end
    return valueMap, true
end

---获取所有的值。按key的顺序排序。
---@type Node[]
M.values = nil

---@param self Node.Table
---@return Node[]
---@return true
M.__getter.values = function (self)
    local rt = self.scope.rt
    local values = {}

    for i, key in ipairs(self.keys) do
        values[i] = self.valueMap[rt.luaKey(key)]
    end

    return values, true
end

function M:isTableLike()
    return true
end

---@type Node?
M.expectParent = nil

---@param parent Node
function M:setExpectParent(parent)
    self.expectParent = parent
end

---@param key Node.Key
---@return Node
---@return boolean exists
function M:getExpect(key)
    if not self.expectParent then
        return self.scope.rt.NIL, false
    end
    return self.expectParent:getExpect(key)
end

---@param key Node.Key
---@return Node
---@return boolean exists
function M:get(key)
    local rt = self.scope.rt
    local r, e = self:getExpect(key)
    if e then
        local tp = r:simplify()
        if tp.kind == 'type' and tp ~= rt.ANY and tp ~= rt.UNKNOWN and tp ~= rt.NIL then
            return r, true
        end
    end
    if not self.fields then
        return rt.NIL, false
    end
    key = rt.nodeKey(key)
    if key.kind == 'value' then
        ---@cast key Node.Value
        local result = self.valueMap[rt.luaKey(key)]
        if result then
            return result, true
        end
        for field in self.fields:pairsFast() do
            ---@cast field Node.Field
            if key:canCast(field.key) then
                return field.value, true
            end
        end
        return rt.NIL, false
    end
    if key.kind == 'union' then
        ---@cast key Node.Union
        ---@type Node[]
        local results = {}
        for _, v in ipairs(key.values) do
            local r = self:get(v)
            results[#results+1] = r
        end
        if #results == 0 then
            return rt.NIL, false
        end
        return rt.union(results), true
    end
    ---@cast key Node
    local typeName = key.typeName
    if typeName == 'never'
    or typeName == 'nil' then
        return key, true
    end
    if typeName == 'any'
    or typeName == 'unknown' then
        if #self.values == 0 then
            return rt.NIL, false
        end
        return rt.union(self.values), true
    end
    local result = {}
    for field in self.fields:pairsFast() do
        ---@cast field Node.Field
        if field.key >> key or key >> field.key then
            result[#result+1] = field.value
        end
    end
    if #result == 0 then
        return rt.NIL, false
    end
    return rt.union(result), true
end

function M:keyOf(value)
    local rt = self.scope.rt
    if not self.fields then
        return rt.NEVER
    end
    local keys = {}
    for field in self.fields:pairsFast() do
        ---@cast field Node.Field
        if field.value >> value or value >> field.value then
            keys[#keys+1] = field.key
        end
    end
    if #keys == 0 then
        return rt.NEVER
    end
    return rt.union(keys)
end

---@param other Node
---@return boolean
function M:onCanBeCast(other)
    if self == other then
        return true
    end
    if not other:isTableLike() then
        return false
    end
    for _, key in ipairs(self.keys) do
        local v = other:get(key)
        local myType = self:get(key)
        if not v:canCast(myType) then
            return false
        end
    end
    return true
end

---@param other Node
---@return boolean
function M:onCanCast(other)
    local rt = self.scope.rt
    if not other:isTableLike() then
        return false
    end
    if other.kind == 'array' then
        ---@cast other Node.Array
        local myType = self:get(rt.INTEGER)
        if myType:canCast(other.head) then
            return true
        elseif myType ~= rt.NIL then
            return false
        end
        for _, key in ipairs(self.keys) do
            if  key.kind == 'value'
            and type(key.literal) == 'number'
            and key.literal % 1 == 0
            and key.literal >= 1 then
                local v = self.valueMap[key.literal]
                if not v:canCast(other.head) then
                    return false
                end
            end
        end
        return true
    end
    if other.value ~= other then
        return self:canCast(other.value)
    end
    return false
end

---@param a Node.Field
---@param b Node.Field
---@return Node.Field
local function defaultOnSameKey(a, b)
    if a == b then
        return a
    end
    local v1 = a:findValue { 'type', 'table' }
    local v2 = b:findValue { 'type', 'table' }
    if not v1 or v1.kind == 'type' or not v2 or v2.kind == 'type' then
        return a
    end
    if v1 == v2 then
        return a
    end
    ---@cast v1 Node.Table
    ---@cast v2 Node.Table
    local rt = a.scope.rt
    local merged = rt.mergeTables({ v1, v2 })
    local field = rt.field(a.key, merged)
    local location = a.location or b.location
    if location then
        field:setLocation(location)
    end
    return field
end

---越靠前的字段越优先。
---@param childs Node
---@param onSameKey? fun(oldField: Node.Field, newField: Node.Field): Node.Field
---@return Node.Table
function M:addChilds(childs, onSameKey)
    local rt = self.scope.rt
    rt:lockCache()

    if not onSameKey then
        onSameKey = defaultOnSameKey
    end

    assert(self.fields == nil, 'Must be an empty table when merging childs.')

    ---@type table<Node.Key, Node.Field>
    local allFields = {}
    ---@type Node.Key[]
    local keys = {}
    for _, child in ipairs(childs) do
        local value = child.value
        if value.kind ~= 'table' then
            value = value:findValue { 'table' }
            if not value then
                goto continue
            end
        end
        ---@cast value Node.Table
        if value.locations then
            for _, loc in ipairs(value.locations) do
                self:addLocation(loc)
            end
        end
        if value.fields then
            for k, field in pairs(value.valueMap) do
                if not allFields[k] then
                    allFields[k] = field
                    keys[#keys+1] = k
                else
                    local new = onSameKey(allFields[k], field)
                    allFields[k] = new
                end
            end
        end
        ::continue::
    end

    for _, k in ipairs(keys) do
        local field = allFields[k]
        self:addField(field)
    end

    rt:unlockCache()
    return self
end

---@param self Node.Table
---@return boolean
---@return true
M.__getter.hasGeneric = function (self)
    if not self.fields then
        return false, true
    end
    self.hasGeneric = false
    local hasGeneric = false
    for field in self.fields:pairsFast() do
        field:addRef(self)
        if field.hasGeneric then
            hasGeneric = true
        end
    end
    return hasGeneric, true
end

function M:resolveGeneric(map)
    if not self.hasGeneric then
        return self
    end
    local newTable = self.scope.rt.table()
    ---@param field Node.Field
    for field in self.fields:pairsFast() do
        newTable:addField(field:resolveGeneric(map))
    end
    newTable.locations = self.locations
    return newTable
end

function M:inferGeneric(other, result)
    if not self.hasGeneric then
        return
    end
    local rt = self.scope.rt
    ---@type Node[]
    local knownKeys   = {}
    ---@type Node[]
    local knownValues = {}

    ---@type Node.Field[]
    local fieldsK  = {}
    ---@type Node.Field[]
    local fieldsV  = {}
    ---@type Node.Field[]
    local fieldsKV = {}
    ---@param field Node.Field
    for field in self.fields:pairsFast() do
        local key   = field.key
        local value = field.value
        if key.hasGeneric and not value.hasGeneric then
            fieldsK[#fieldsK+1] = field
        end
        if not key.hasGeneric and value.hasGeneric then
            fieldsV[#fieldsV+1] = field
        end
        if key.hasGeneric and value.hasGeneric then
            fieldsKV[#fieldsKV+1] = field
        end
        if not key.hasGeneric then
            knownKeys[#knownKeys+1] = field.key
        end
        if not value.hasGeneric then
            knownValues[#knownValues+1] = field.value
        end
    end

    for _, field in ipairs(fieldsK) do
        local value = field.value
        local key   = other:keyOf(value)
        field.key:inferGeneric(key, result)
    end
    for _, field in ipairs(fieldsV) do
        local key   = field.key
        local value = other:get(key)
        field.value:inferGeneric(value, result)
    end
    for _, field in ipairs(fieldsK) do
        local key = field.key:resolveGeneric(result)
        knownKeys[#knownKeys+1] = key
    end
    for _, field in ipairs(fieldsV) do
        local value = field.value:resolveGeneric(result)
        knownValues[#knownValues+1] = value
    end
    if #fieldsKV > 0 then
        local knownKey   = rt.union(knownKeys)
        local knownValue = rt.union(knownValues)
        local _, otherKey   = other.typeOfKey:narrow(knownKey)
        local _, otherValue = other:get(rt.ANY):narrow(knownValue)
        for _, field in ipairs(fieldsKV) do
            field.key:inferGeneric(otherKey, result)
            field.value:inferGeneric(otherValue, result)
        end
    end
end

function M:onView(viewer, options)
    if #self.keys == 0 then
        return '{}'
    end

    local visited = viewer.visited

    if visited[self] > 1
    or viewer.skipLevel >= 10 then
        return '{ ... }'
    end
    if self.locations then
        for _, loc in ipairs(self.locations) do
            if visited[loc] then
                return '{ ... }'
            end
            visited[loc] = true
        end
    end

    local fields = {}
    local rt = self.scope.rt

    local skipped
    ---@param field Node.Field
    ---@return boolean
    local function checkSkip(field)
        local location = field.location
        if location then
            if visited[location] then
                skipped = true
                return true
            end
            visited[location] = true
        end
        local value = field.value
        if value.kind == 'variable' then
            ---@cast value Node.Variable
            for assign in value:eachAssign() do
                if checkSkip(assign) then
                    return true
                end
            end
        end
        return false
    end

    for _, key in ipairs(self.keys) do
        local field = self.fieldMap[key]
        if #field == 0 then
            if field.hideInView then
                goto continue
            end
            if checkSkip(field) then
                goto continue
            end
        else
            for _, f in ipairs(field) do
                if f.hideInView then
                    goto continue
                end
                if checkSkip(f) then
                    goto continue
                end
            end
        end
        ---@type Node.Key
        local k = rt.luaKey(key)
        local value = self.valueMap[k]
        fields[#fields+1] = string.format('%s: %s'
            , viewer:viewAsKey(key)
            , viewer:view(value)
        )
        ::continue::
    end

    if skipped then
        fields[#fields+1] = '...'
    end

    if #fields == 0 then
        return '{}'
    end

    return '{ ' .. table.concat(fields, ', ') .. ' }'
end
