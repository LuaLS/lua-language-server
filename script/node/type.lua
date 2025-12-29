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

function M:isTableLike()
    if self:isClassLike() then
        return true
    end
    if self.value == self then
        return false
    end
    return self.value:isTableLike()
end

---@type Node.Class[]?
M.classes = nil

---@param class Node.Class
---@return Node.Type
function M:addClass(class)
    if not self.classes then
        self.classes = {}
    end
    table.insert(self.classes, class)

    self:flushCache()
    class:addRef(self)

    return self
end

---@param class Node.Class
function M:removeClass(class)
    if not self.classes then
        return
    end
    ls.util.arrayRemove(self.classes, class, true)
    if #self.classes == 0 then
        self.classes = nil
    end

    self:flushCache()
end

---@type Node.Alias[]?
M.aliases = nil

---@param alias Node.Alias
---@return Node.Type
function M:addAlias(alias)
    if not self.aliases then
        self.aliases = {}
    end
    table.insert(self.aliases, alias)

    self:flushCache()
    alias:addRef(self)

    return self
end

---@param alias Node.Alias
---@return Node.Type
function M:removeAlias(alias)
    if not self.aliases then
        return self
    end
    ls.util.arrayRemove(self.aliases, alias, true)
    if #self.aliases == 0 then
        self.aliases = nil
    end

    self:flushCache()

    return self
end

---@param protos? LinkedTable
---@param args? Node[]
---@return (Node.Class | Node.Alias)[]
function M:getProtos(protos, args)
    ---@type (Node.Class | Node.Alias)[]
    local results = {}

    if not protos then
        return results
    end

    local nargs = args and #args or 0
    ---@param proto Node.Class | Node.Alias
    for _, proto in ipairs(protos) do
        proto:addRef(self)
        local nparams = proto.params and #proto.params or 0
        if nparams ~= nargs then
            goto continue
        end
        if nparams == 0 then
            results[#results+1] = proto
            goto continue
        end
        ---@cast args -?
        for i = 1, nparams do
            local param = proto.params[i]
            local arg = args[i]
            if not (arg >> param.extends) then
                goto continue
            end
        end
        results[#results+1] = proto
        ::continue::
    end

    if nargs == 0 then
        return results
    end

    ---@cast args -?
    local params = {}
    for i, result in ipairs(results) do
        params[i] = ls.util.map(result.params, function (v)
            return v.extends
        end)
    end

    local matchs = self.scope.rt:getBestMatchs(params, nargs)
    local finalResults = ls.util.map(matchs, function (i)
        return results[i]
    end)

    return finalResults
end

---@type Node.Class[]
M.protoClasses = nil

---@param self Node.Type
---@return Node.Class[]
---@return true
M.__getter.protoClasses = function (self)
    return self:getProtos(self.classes), true
end

---@type Node.Alias[]
M.protoAliases = nil

---@param self Node.Type
---@return Node.Alias[]
---@return true
M.__getter.protoAliases = function (self)
    return self:getProtos(self.aliases), true
end

--- 获取我的继承
---@type Node.Class.ExtendAble[]
M.extends = nil

---@param self Node.Type
---@return Node.Class.ExtendAble[]
---@return true
M.__getter.extends = function (self)
    local results = {}
    for _, class in ipairs(self.protoClasses) do
        if class.extends then
            for _, ext in ipairs(class.extends) do
                results[#results+1] = ext
            end
        end
    end
    return results, true
end

--- 获取所有继承（广度优先）
---@type Node.Class.ExtendAble[]
M.fullExtends = nil

---@param self Node.Type
---@return Node.Class.ExtendAble[]
---@return true
M.__getter.fullExtends = function (self)
    return self.scope.rt:calcFullExtends(self), true
end

--- 所有继承的合并表
---@type Node.Table
M.extendsTable = nil

---@param self Node.Type
---@return Node.Table
---@return true
M.__getter.extendsTable = function (self)
    if #self.fullExtends == 0 then
        return self.scope.rt.table(), true
    end

    ---@type Node.Table[]
    local tables = {}
    for _, v in ipairs(self.fullExtends) do
        if v.kind == 'table' then
            ---@cast v Node.Table
            tables[#tables+1] = v
        elseif v.kind == 'type' then
            ---@cast v Node.Type
            tables[#tables+1] = v.fieldTable
            tables[#tables+1] = v.variableTable
        else
            ---@cast v -Node.Table, -Node.Type
            local vv = v.value
            if vv.kind == 'table' then
                ---@cast vv Node.Table
                tables[#tables+1] = vv
            end
        end
    end

    local table = self.scope.rt.mergeTables(tables)

    return table, true
end

--- 类型自身的字段合并表（一般是通过 ---@field 添加）
---@type Node.Table
M.fieldTable = nil

---@param self Node.Type
---@return Node.Table
---@return true
M.__getter.fieldTable = function (self)
    local fieldsTable = {}
    if self.classes then
        for _, class in ipairs(self.protoClasses) do
            class:addRef(self)
            fieldsTable[#fieldsTable+1] = class.fields
        end
    end
    local table = self.scope.rt.mergeTables(fieldsTable)
    return table, true
end

-- 绑定变量的字段合并表
---@type Node.Table
M.variableTable = nil

---@param self Node.Type
---@return Node.Table
---@return true
M.__getter.variableTable = function (self)
    local variableTables = {}
    for _, class in ipairs(self.protoClasses) do
        if class.variables then
            for _, variable in ipairs(class.variables) do
                variable:addRef(self)
                if variable.fields then
                    variableTables[#variableTables+1] = variable.fields
                end
            end
        end
    end
    local table = self.scope.rt.mergeTables(variableTables)
    return table, true
end

---@type Node
M.extendsValue = nil

---@param self Node.Type
---@return Node
---@return true
M.__getter.extendsValue = function (self)
    self.extendsValue = self.scope.rt.NEVER
    if not self:isComplex() then
        return self, true
    end
    if self:isClassLike() then
        local merging = {}
        -- 1. 直接写在 class 里的字段
        merging[#merging+1] = self.fieldTable
        -- 2. 绑定的变量里的字段
        merging[#merging+1] = self.variableTable
        -- 3. 继承来的字段
        merging[#merging+1] = self.extendsTable

        local value = self.scope.rt.mergeTables(merging)
        return value, true
    end
    if self:isAliasLike() then
        ---@type Node[]
        local aliases = {}
        ---@param alias Node.Alias
        for _, alias in ipairs(self.protoAliases) do
            if alias.value then
                aliases[#aliases+1] = alias.value
            end
        end
        local union = self.scope.rt.union(aliases)
        return union, true
    end
    return self, true
end

---@type Node
M.value = nil

---@param self Node.Type
---@return Node
---@return true
M.__getter.value = function (self)
    if self.isBasicType then
        return self, true
    end
    return self.extendsValue, true
end

---@type Node
M.expectValue = nil

---@param self Node.Type
---@return Node
---@return true
M.__getter.expectValue = function (self)
    self.expectValue = self.scope.rt.NEVER
    if not self:isComplex() then
        return self, true
    end
    if self:isClassLike() then
        local merging = {}
        -- 1. 直接写在 class 里的字段
        merging[#merging+1] = self.fieldTable

        return self.scope.rt.mergeTables(merging), true
    end
    if self:isAliasLike() then
        ---@type Node[]
        local aliases = {}
        ---@param alias Node.Alias
        for _, alias in ipairs(self.protoAliases) do
            if alias.value then
                aliases[#aliases+1] = alias.value
            end
        end
        local union = self.scope.rt.union(aliases)
        return union, true
    end
    return self, true
end

---@param self Node.Type
---@return Node
---@return true
M.__getter.truly = function (self)
    if self:isAliasLike() then
        local truly = self.value.truly
        if truly == self.value then
            return self, true
        else
            return truly, true
        end
    end
    return self, true
end

---@param self Node.Type
---@return Node
---@return true
M.__getter.falsy = function (self)
    if self:isAliasLike() then
        local falsy = self.value.falsy
        if falsy == self.value then
            return self, true
        else
            return falsy, true
        end
    end
    if self:isClassLike() then
        return self.scope.rt.NEVER, true
    end
    return self, true
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
    if self._onCanBeCast then
        ---@cast other Node.Type
        local res = self._onCanBeCast(self, other)
        if res ~= nil then
            return res
        end
    end
    if self.isBasicType then
        return
    end
    if self:isClassLike() then
        if other.kind == 'type' then
            return
        end
        return other:canCast(self.value)
    end
    if self:isAliasLike() then
        return other:canCast(self.value)
    end
end

---@param other Node
---@return boolean
function M:onCanCast(other)
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

function M:narrowEqual(other)
    local rt = self.scope.rt
    other = other:finalValue()
    if self == other then
        return self, rt.NEVER
    end

    if self == rt.ANY then
        if other == rt.NIL then
            return rt.NIL, rt.UNKNOWN
        end
        if other == rt.UNKNOWN then
            return rt.UNKNOWN, rt.NIL
        end
        if other == rt.TRULY then
            return rt.TRULY, rt.FALSY
        end
        if other == rt.FALSY then
            return rt.FALSY, rt.TRULY
        end
        return other, self
    end
    if self == rt.UNKNOWN then
        if other == rt.NIL then
            return rt.NEVER, self
        end
        if other == rt.TRULY then
            return self, rt.FALSE
        end
        if other == rt.FALSY then
            return rt.FALSE, self
        end
        return other, self
    end

    local l = self:findValue(ls.node.kind['value'] | ls.node.kind['union'])
    if l then
        return l:narrowEqual(other)
    end

    return rt.NEVER, self
end

---@param key Node.Key
---@return Node
---@return boolean exists
function M:get(key)
    if self.extendsValue == self then
        return self.scope.rt.NEVER, false
    end
    return self.extendsValue:get(key)
end

M.hasGeneric = false

---@private
---@type PathTable
M.callCache = nil

---@param nodes Node[]
---@return Node.Type | Node.Call
function M:call(nodes)
    if not self.callCache then
        self.callCache = ls.tools.pathTable.create(true, true)
    end
    local call = self.callCache:get(nodes)
    if not call then
        call = self.scope.rt.call(self.typeName, nodes)
        self.callCache:set(nodes, call)
    end
    return call
end

function M:onView(viewer, options)
    return self.typeName
end
