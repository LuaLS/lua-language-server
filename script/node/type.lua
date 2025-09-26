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
    if self.classLocations
    or self.table
    or self.extends
    or self.variables then
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

---@param extends Node.Type | Node.Call | Node.Table
---@return Node.Type
function M:addExtends(extends)
    if not self.extends then
        self.extends = ls.linkedTable.create()
    end
    self.extends:pushTail(extends)

    extends:flushMe(self, true)
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

    extends:flushMe(self, false)
    self:flushCache()

    return self
end

---@type Node.Location[]
M.aliasLocations = nil

---@param alias Node
---@param location? Node.Location
---@return Node.Type
function M:addAlias(alias, location)
    if not self.alias then
        self.alias = ls.linkedTable.create()
    end
    self.alias:pushTail(alias)

    if location then
        if not self.aliasLocations then
            self.aliasLocations = {}
        end
        self.aliasLocations[#self.aliasLocations+1] = location
    end

    self:flushCache()

    return self
end

---@param alias Node
---@param location? Node.Location
---@return Node.Type
function M:removeAlias(alias, location)
    if not self.alias then
        return self
    end
    self.alias:pop(alias)
    if self.alias:getSize() == 0 then
        self.alias = nil
    end

    if location and self.aliasLocations then
        ls.util.arrayRemove(self.aliasLocations, location)
        if #self.aliasLocations == 0 then
            self.aliasLocations = nil
        end
    end

    self:flushCache()

    return self
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
        if self.variables then
            ---@param variable Node.Variable
            for variable in self.variables:pairsFast() do
                merging[#merging+1] = variable.fields
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
        if self.alias:getSize() == 1 then
            local head = self.alias:getHead()
            return head, true
        end
        local alias = self.alias:toArray()
        local union = self.scope.node.union(alias)
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
    if self.paramPacks and not self._hideEmptyArgs then
        return self.typeName .. self.paramPacks[1]:view(skipLevel)
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
    if self.paramPacks then
        return self:call():get(key)
    end
    if self.value == self then
        return self.scope.node.NEVER
    end
    return self.value:get(key)
end

---@param self Node.Type
---@return boolean
---@return true
M.__getter.hasGeneric = function (self)
    return self.paramPacks ~= nil, true
end

---@param args Node[]
---@return Node
function M:getValueWithArgs(args)
    if not self.paramPacks then
        return self.value
    end
    local map = {}
    for _, pack in ipairs(self.paramPacks) do
        for i, param in ipairs(pack.generics) do
            map[param] = args[i] or param.value
        end
    end
    local resolvedValue = self.value:resolveGeneric(map)
    return resolvedValue
end

---@param map table<Node.Generic, Node>
---@return Node.Type | Node.Call
function M:resolveGeneric(map)
    if not self.paramPacks then
        return self
    end
    local pack = self.paramPacks[1]
    local nodes = {}
    for _, param in ipairs(pack.generics) do
        nodes[#nodes+1] = map[param] or param
    end
    return self:call(nodes)
end

---@param nodes? Node[]
---@return Node.Type | Node.Call
function M:call(nodes)
    if not self.paramPacks then
        return self
    end
    if not nodes then
        nodes = {}
    end
    local call
    if #nodes == 0 then
        call = self.callWithNoArgs
    else
        call = self.callCache:get(nodes)
    end
    if not call then
        call = self.scope.node.call(self.typeName, nodes)
        if #nodes == 0 then
            self.callWithNoArgs = call
        else
            self.callCache:set(nodes, call)
        end
    end
    return call
end

---@private
---@type Node.Call?
M.callWithNoArgs = nil

---@private
---@type PathTable
M.callCache = nil

---@param self Node.Type
---@return PathTable
---@return true
M.__getter.callCache = function (self)
    return ls.pathTable.create(true, true), true
end
