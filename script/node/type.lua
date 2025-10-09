---@class Node.Type: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(name: string): Node.Type
local M = ls.node.register 'Node.Type'

M.kind = 'type'

---@param scope Scope
---@param name string
function M:__init(scope, name)
    self.typeName = name
    self.scope = scope
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
    return self:isClassLike()
        or self:isAliasLike()
end

---@return boolean
function M:isClassLike()
    return self.classes ~= nil
end

function M:isAliasLike()
    return self.aliases ~= nil
end

---@type LinkedTable
M.classes = nil

---@param class Node.Class
function M:addClass(class)
    if not self.classes then
        self.classes = ls.linkedTable.create()
    end
    self.classes:pushTail(class)

    self:flushCache()
end

---@param class Node.Class
function M:removeClass(class)
    if not self.classes then
        return
    end
    self.classes:pop(class)
    if self.classes:getSize() == 0 then
        self.classes = nil
    end

    self:flushCache()
end

---@type LinkedTable
M.aliases = nil

---@param alias Node.Alias
---@return Node.Type
function M:addAlias(alias)
    if not self.aliases then
        self.aliases = ls.linkedTable.create()
    end
    self.aliases:pushTail(alias)

    self:flushCache()

    return self
end

---@param alias Node.Alias
---@return Node.Type
function M:removeAlias(alias)
    if not self.aliases then
        return self
    end
    self.aliases:pop(alias)
    if self.aliases:getSize() == 0 then
        self.aliases = nil
    end

    self:flushCache()

    return self
end

--- 获取所有继承（广度优先）
---@type (Node.Type | Node.Table)[]
M.fullExtends = nil

---@param self Node.Type
---@return (Node.Type | Node.Table)[]
---@return true
M.__getter.fullExtends = function (self)
    local result = {}
    local visitedTypes = {}
    local visitedResults = {}

    ---@param t Node.Type
    ---@param nextQueue Node.Type[]
    local function searchClasses(t, nextQueue)
        if visitedTypes[t] then
            return
        end
        visitedTypes[t] = true
        if not t.classes then
            return
        end
        ---@param class Node.Class
        for class in t.classes:pairsFast() do
            if class.extends and not class.params then
                for _, ext in ipairs(class.extends) do
                    if visitedResults[ext] then
                        goto continue
                    end
                    visitedResults[ext] = true
                    result[#result+1] = class
                    if ext.kind == 'type' then
                        ---@cast ext Node.Type
                        nextQueue[#nextQueue+1] = ext
                    end
                    ::continue::
                end
            end
        end
    end

    ---@param queue Node.Type[]
    local function search(queue)
        local nextQueue = {}
        for _, v in ipairs(queue) do
            searchClasses(v, nextQueue)
        end
        if #nextQueue == 0 then
            return
        end
        search(nextQueue)
    end

    search { self }

    return result, true
end

--- 所有继承的合并表
---@type Node.Table
M.extendsTable = nil

---@param self Node.Type
---@return Node.Table
---@return true
M.__getter.extendsTable = function (self)
    local table = self.scope.node.table()
    if #self.fullExtends == 0 then
        return table, true
    end

    ---@type Node.Table[]
    local tables = {}
    for _, v in ipairs(self.fullExtends) do
        if v.kind == 'table' then
            ---@cast v Node.Table
            tables[#tables+1] = v
        elseif v.kind == 'type' then
            ---@cast v Node.Type
            tables[#tables+1] = v.table
        else
            ---@cast v -Node.Table, -Node.Type
            local vv = v.value
            if vv.kind == 'table' then
                ---@cast vv Node.Table
                tables[#tables+1] = vv
            end
        end
    end
    table:extends(tables)

    return table, true
end

--- 类型自身的字段（一般是通过 ---@field 添加）
---@type Node.Table
M.table = nil

---@param self Node.Type
---@return Node.Table
---@return true
M.__getter.table = function (self)
    local table = self.scope.node.table()
    if self.classes then
        ---@type Node.Table[]
        local fields = {}
        ---@param class Node.Class
        for class in self.classes:pairsFast() do
            if not class.params then
                fields[#fields+1] = class.fields
            end
        end
        table:extends(fields)
    end
    return table, true
end

---@type Node
M.value = nil

---@param self Node.Type
---@return Node
---@return true
M.__getter.value = function (self)
    self.value = self.scope.node.NEVER
    if not self:isComplex() then
        return self, true
    end
    if self:isClassLike() then
        local merging = {}
        -- 1. 直接写在 class 里的字段
        merging[#merging+1] = self.table
        -- 2. 绑定的变量里的字段
        for class in self.classes:pairsFast() do
            ---@cast class Node.Class
            if class.variables and not class.params then
                for variable in class.variables:pairsFast() do
                    merging[#merging+1] = variable.fields
                end
            end
        end
        -- 3. 继承来的字段
        if not self.extendsTable:isEmpty() then
            merging[#merging+1] = self.extendsTable
        end

        if #merging == 1 then
            return merging[1], true
        end

        local value = self.scope.node.table()
        value:extends(merging)
        return value, true
    end
    if self:isAliasLike() then
        ---@type Node[]
        local aliases = {}
        ---@param alias Node.Alias
        for alias in self.aliases do
            if alias.extends and not alias.params then
                ls.util.arrayMerge(aliases, alias.extends)
            end
        end
        local union = self.scope.node.union(aliases)
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
    return self.scope.node.NEVER, true
end

function M:view(skipLevel)
    return self.typeName
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
    if self.value == self then
        return self.scope.node.NEVER
    end
    return self.value:get(key)
end

M.hasGeneric = false

---@param nodes Node[]
---@return Node.Type | Node.Call
function M:call(nodes)
    local call = self.callCache:get(nodes)
    if not call then
        call = self.scope.node.call(self.typeName, nodes)
        self.callCache:set(nodes, call)
    end
    return call
end

---@private
---@type PathTable
M.callCache = nil

---@param self Node.Type
---@return PathTable
---@return true
M.__getter.callCache = function (self)
    return ls.pathTable.create(true, true), true
end
