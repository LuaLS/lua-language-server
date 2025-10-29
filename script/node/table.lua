---@class Node.Table: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(scope: Scope, fields?: table): Node.Table
local M = ls.node.register 'Node.Table'

M.kind = 'table'

---@class Node.Field
---@field key Node
---@field value? Node
---@field location? Node.Location
---@field hideInView? boolean

---@type LinkedTable?
M.fields = nil

---@param scope Scope
---@param fields? table
function M:__init(scope, fields)
    self.scope = scope
    if fields then
        self.fields = ls.tools.linkedTable.create()
        for k, v in pairs(fields) do
            if type(k) ~= 'table' then
                k = scope.rt.value(k)
            end
            if type(v) ~= 'table' then
                v = scope.rt.value(v)
            end
            self.fields:pushTail { key = k, value = v }
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

    local function merge(field, old)
        if not old then
            return field
        end
        if #old == 0 then
            return { old, field }
        else
            old[#old+1] = field
            return old
        end
    end

    ---@param field Node.Field
    for field in self.fields:pairsFast() do
        local key = field.key.solve
        if key.kind == 'union' then
            ---@cast key Node.Union
            for _, k in ipairs(key.values) do
                fieldMap[k] = merge(field, fieldMap[k])
            end
        else
            fieldMap[key] = merge(field, fieldMap[key])
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

---@type table<Node.Key, Node>
M.valueMap = nil

---@param self Node.Table
---@return table<Node, Node>
---@return true
M.__getter.valueMap = function (self)
    local valueMap = {}
    for k, field in pairs(self.fieldMap) do
        local v
        if #field > 0 then
            v = self.scope.rt.union(ls.util.map(field, function (v, k)
                return v.value
            end))
        else
            v = field.value
        end
        if not v then
            goto continue
        end
        if k.kind == 'value' then
            valueMap[k.literal] = v
        else
            valueMap[k] = v
        end
        ::continue::
    end
    return valueMap, true
end

---@type Node.Field[]
M.typeFields = nil

---@param self Node.Table
---@return Node.Field[]
---@return true
M.__getter.typeFields = function (self)
    local fields = {}
    if not self.fields then
        return fields, true
    end
    ---@param field Node.Field
    for field in self.fields:pairsFast() do
        if field.key.solve.kind ~= 'value' then
            fields[#fields+1] = field
        end
    end
    return fields, true
end

---获取所有的值。按key的顺序排序。
---@type Node[]
M.values = nil

---@param self Node.Table
---@return Node[]
---@return true
M.__getter.values = function (self)
    local values = {}

    for i, key in ipairs(self.keys) do
        if key.kind == 'value' then
            values[i] = self.valueMap[key.literal]
        else
            values[i] = self.valueMap[key]
        end
    end

    return values, true
end

---@param key Node.Key
---@return Node
---@return boolean exists
function M:get(key)
    local rt = self.scope.rt
    if not self.fields then
        return rt.NIL, false
    end
    if type(key) ~= 'table' then
        ---@cast key -Node
        key = rt.value(key)
    end
    if key.kind == 'value' then
        ---@cast key Node.Value
        local result = self.valueMap[key.literal]
        if result then
            return result, true
        end
        return self:get(key.nodeType)
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
    local value = self.valueMap[key]
    if value then
        return value, true
    end
    for _, field in ipairs(self.typeFields) do
        if key:canCast(field.key) then
            return field.value, true
        end
    end
    return rt.NIL, false
end

---@param other Node
---@return boolean
function M:onCanBeCast(other)
    if self == other then
        return true
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
    return false
end

---越靠前的字段越优先。
---@param childs Node.Table[]
function M:addChilds(childs)
    local rt = self.scope.rt
    rt:lockCache()

    local fieldMap = self.fieldMap
    local addedKeys = {}
    for _, child in ipairs(childs) do
        local value = child.value
        if value.kind == 'table' then
            ---@cast value Node.Table
            for key, field in pairs(value.fieldMap) do
                if  not addedKeys[key]
                and not fieldMap[key] then
                    addedKeys[key] = true
                    self:addField(field)
                end
            end
        end
    end

    rt:unlockCache()
end

---@param self Node.Table
---@return boolean
---@return true
M.__getter.hasGeneric = function (self)
    if not self.fields then
        return false, true
    end
    for field in self.fields:pairsFast() do
        if field.key.hasGeneric or field.value.hasGeneric then
            return true, true
        end
    end
    return false, true
end

function M:resolveGeneric(map)
    if not self.hasGeneric then
        return self
    end
    local newTable = self.scope.rt.table()
    ---@param field Node.Field
    for field in self.fields:pairsFast() do
        if field.key.hasGeneric
        or field.value.hasGeneric then
            newTable:addField {
                key   = field.key:resolveGeneric(map),
                value = field.value:resolveGeneric(map),
            }
        else
            newTable:addField(field)
        end
    end
    return newTable
end

function M:inferGeneric(other, result)
    if not self.hasGeneric then
        return
    end
    ---@param field Node.Field
    for field in self.fields:pairsFast() do
        if field.key.hasGeneric then
            -- 仅支持 [K] 这种形式的推导，不支持 [K[]] 等嵌套形式
            if  field.key.kind == 'generic'
            and other.typeOfKey ~= self.scope.rt.NEVER then
                field.key:inferGeneric(other.typeOfKey, result)
                if field.value.hasGeneric then
                    field.value:inferGeneric(other:get(self.scope.rt.ANY), result)
                end
            end
        elseif field.value.hasGeneric then
            field.value:inferGeneric(other:get(field.key), result)
        end
    end
end

function M:onView(viewer, options)
    if #self.keys == 0 then
        return '{}'
    end

    if viewer.visited[self] > 1 then
        return '{...}'
    end

    local fields = {}

    for _, key in ipairs(self.keys) do
        local field = self.fieldMap[key]
        if #field == 0 then
            if field.hideInView then
                goto continue
            end
        else
            for _, f in ipairs(field) do
                if f.hideInView then
                    goto continue
                end
            end
        end
        ---@type Node.Key
        local k = key
        if k.kind == 'value' then
            k = k.literal
        end
        local value = self.valueMap[k]
        fields[#fields+1] = string.format('%s: %s'
            , viewer:viewAsKey(key)
            , viewer:view(value)
        )
        ::continue::
    end

    if #fields == 0 then
        return '{}'
    end

    return '{ ' .. table.concat(fields, ', ') .. ' }'
end
