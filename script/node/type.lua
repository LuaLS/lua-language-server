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
---@return Node.Type
function M:addField(field)
    if not self.table then
        self.table = ls.node.table()
    end
    self.table:addField(field)
    self.value = nil
    return self
end

---@param field Node.Field
---@return Node.Type
function M:removeField(field)
    if not self.table then
        return self
    end
    self.table:removeField(field)
    if self.table:isEmpty() then
        self.table = nil
    end
    self.value = nil
    return self
end

---@type boolean
M.isBasicType = nil

---@param self Node.Type
---@return boolean
---@return true
M.__getter.isBasicType = function (self)
    if self._basicType then
        return true, true
    end
    if self:isComplex() then
        return false, true
    end
    return false, true
end

---@return boolean
function M:isComplex()
    if self.table
    or self.extends
    or self.alias then
        return true
    end
    return false
end

---@return boolean
function M:isClassLike()
    if self.table
    or self.extends then
        return true
    end
    return false
end

function M:isAliasLike()
    if  self.alias
    and not self.table
    and not self.extends then
        return true
    end
    return false
end

---@param extends Node.Type | Node.Table
---@return Node.Type
function M:addExtends(extends)
    if not self.extends then
        self.extends = ls.linkedTable.create()
    end
    self.extends:pushTail(extends)

    self:flushCache()
    return self
end

---@param extends Node
---@return self
function M:removeExtends(extends)
    if not self.extends then
        return self
    end
    self.extends:pop(extends)
    if self.extends:getSize() == 0 then
        self.extends = nil
    end

    self:flushCache()

    return self
end

---@param alias Node
---@return Node.Type
function M:addAlias(alias)
    if not self.alias then
        self.alias = ls.linkedTable.create()
    end
    self.alias:pushTail(alias)

    self:flushCache()

    return self
end

function M:removeAlias(alias)
    if not self.alias then
        return self
    end
    self.alias:pop(alias)
    if self.alias:getSize() == 0 then
        self.alias = nil
    end

    self:flushCache()

    return self
end

function M:flushCache()
    self.value = nil
    self.fullExtends = nil
    self.extendsTable  = nil
    self.isBasicType = nil
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
M.extendsTable = nil

---获取所有继承的合并表
---@param self Node.Type
---@return Node.Table
---@return true
M.__getter.extendsTable = function (self)
    local table = ls.node.table()

    table:extends(self.fullExtends)

    return table, true
end

---@type Node
M.value = nil

---@param self Node.Type
---@return Node
---@return true
M.__getter.value = function (self)
    self.value = ls.node.NEVER
    if not self:isComplex() then
        return self, true
    end
    if self:isClassLike() then
        if self.table and self.extends then
            local value = ls.node.table()
            value:extends { self.table, self.extendsTable }
            return value, true
        end
        return self.table or self.extendsTable, true
    end
    if self:isAliasLike() then
        if self.alias:getSize() == 1 then
            local head = self.alias:getHead()
            return head.value, true
        end
        local alias = self.alias:toArray()
        local union = ls.node.union(alias)
        return union.value, true
    end
    return self, true
end

---@param self Node.Type
---@return Node
---@return true
M.__getter.truly = function (self)
    if self:isAliasLike() then
        return self.value.truly, true
    end
    return self, true
end

---@param self Node.Type
---@return Node
---@return true
M.__getter.falsy = function (self)
    if self:isAliasLike() then
        return self.value.falsy, true
    end
    return ls.node.NEVER, true
end

function M:view(skipLevel)
    if self.params and not self._hideEmptyArgs then
        return self.typeName .. self.params:view(skipLevel)
    else
        return self.typeName
    end
end

---@type fun(self: Node.Type, other: Node): boolean?
M._onCanCast = nil

---@type fun(self: Node.Type, other: Node): boolean?
M._onCanBeCast = nil

---@package
---@type boolean
M._basicType = false

---@package
---@type boolean
M._hideEmptyArgs = false

---@overload fun(self, key: 'onCanCast', value: fun(self: Node.Type, other: Node): boolean?): Node.Type
---@overload fun(self, key: 'onCanBeCast', value: fun(self: Node.Type, other: Node): boolean?): Node.Type
---@overload fun(self, key: 'basicType', value: boolean): Node.Type
---@overload fun(self, key: 'hideEmptyArgs', value: boolean): Node.Type
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
    if self.isBasicType then
        return nil
    end
    if self:isClassLike() then
        if other.kind ~= 'type' then
            return false
        end
        ---@cast other Node.Type
        if other:isAliasLike() then
            return false
        end
        return nil
    end
    if self:isAliasLike() then
        return other:canCast(self.value)
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
    if self:isAliasLike() then
        return self.value:canCast(other.value)
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
    if self:isClassLike() then
        return self.value:canCast(other.value)
    end
    return false
end

function M:get(key)
    if self.params then
        return self:call():get(key)
    end
    if self.value == self then
        return ls.node.NEVER
    end
    return self.value:get(key)
end

---@param self Node.Type
---@return boolean
---@return true
M.__getter.hasGeneric = function (self)
    return self.params ~= nil, true
end

---@type Node.GenericPack?
M.params = nil

---@param pack Node.GenericPack
---@return Node.Type
function M:bindParams(pack)
    self.params = pack
    return self
end

---@param args Node[]
---@return Node
function M:getValueWithArgs(args)
    if not self.params then
        return self.value
    end
    local map = {}
    for i, param in ipairs(self.params.generics) do
        map[param] = args[i] or param.default or param.extends
    end
    local resolvedPack = self.params:resolve(map)
    local resolvedValue = self.value:resolveGeneric(resolvedPack)
    return resolvedValue
end

---@param pack Node.GenericPack
---@return Node.Type | Node.Typecall
function M:resolveGeneric(pack)
    if not self.params then
        return self
    end
    local nodes = {}
    for _, param in ipairs(self.params.generics) do
        local value = pack:getGeneric(param) or param
        nodes[#nodes+1] = value
    end
    return self:call(nodes)
end

---@param nodes? Node[]
---@return Node.Type | Node.Typecall
function M:call(nodes)
    if not self.params then
        return self
    end
    if not nodes then
        nodes = {}
    end
    local typecall
    if #nodes == 0 then
        typecall = self.typecallWithNoArgs
    else
        typecall = self.typecallPool:get(nodes)
    end
    if not typecall then
        typecall = ls.node.typecall(self.typeName, nodes)
        if #nodes == 0 then
            self.typecallWithNoArgs = typecall
        else
            self.typecallPool:set(nodes, typecall)
        end
    end
    return typecall
end

---@private
---@type Node.Typecall?
M.typecallWithNoArgs = nil

---@private
---@type PathTable
M.typecallPool = nil


---@param self Node.Type
---@return PathTable
---@return true
M.__getter.typecallPool = function (self)
    return ls.pathTable.create(true, true), true
end

---@type { [string]: Node.Type}
ls.node.TYPE_POOL = setmetatable({}, {
    __mode = 'v',
    __index = function (t, k)
        local v = New 'Node.Type' (k)
        t[k] = v
        return v
    end,
})

---@overload fun(name: string): Node.Type
function ls.node.type(name, pack)
    return ls.node.TYPE_POOL[name]
end
