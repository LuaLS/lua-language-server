---@class Node.Call: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(scope: Scope, head: string | Node, args: Node[]): Node.Call
local M = ls.node.register 'Node.Call'

M.kind = 'call'

---@type Node.Type
M.head = nil

---@param scope Scope
---@param head string
---@param args Node[]
function M:__init(scope, head, args)
    assert(type(head) == 'string')
    self.scope = scope
    self.head = scope.rt.type(head)
    self.args = args
end

---@type Node.Class[]
M.protoClasses = nil

---@param self Node.Call
---@return Node.Class[]
---@return true
M.__getter.protoClasses = function (self)
    self.head:addRef(self)
    for _, arg in ipairs(self.args) do
        arg:addRef(self)
    end
    return self.head:getProtos(self.head.classes, self.args), true
end

---@type Node.Alias[]
M.protoAliases = nil

---@param self Node.Call
---@return Node.Alias[]
---@return true
M.__getter.protoAliases = function (self)
    self.head:addRef(self)
    for _, arg in ipairs(self.args) do
        arg:addRef(self)
    end
    return self.head:getProtos(self.head.aliases, self.args), true
end

--- 获取我的继承
---@type Node.Class.ExtendAble[]
M.extends = nil

---@param self Node.Call
---@return Node.Class.ExtendAble[]
---@return true
M.__getter.extends = function (self)
    local results = {}
    for _, class in ipairs(self.protoClasses) do
        if class.extends then
            class:addRef(self)
            local genericMap = class:makeGenericMap(self.args)
            for _, ext in ipairs(class.extends) do
                results[#results+1] = ext:resolveGeneric(genericMap)
            end
        end
    end
    return results, true
end

--- 获取所有继承（广度优先）
---@type Node.Class.ExtendAble[]
M.fullExtends = nil

---@param self Node.Call
---@return Node.Class.ExtendAble[]
---@return true
M.__getter.fullExtends = function (self)
    return self.scope.rt:calcFullExtends(self), true
end

--- 所有继承的合并表
---@type Node.Table
M.extendsTable = nil

---@param self Node.Call
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

--- 类型自身的字段（一般是通过 ---@field 添加）
---@type Node.Table
M.fieldTable = nil

---@param self Node.Call
---@return Node.Table
---@return true
M.__getter.fieldTable = function (self)
    local head = self.head
    head:addRef(self)
    local fieldsTable = {}
    if head.classes then
        for _, class in ipairs(self.protoClasses) do
            if class.fields then
                class:addRef(self)
                fieldsTable[#fieldsTable+1] = class.fields:resolveGeneric(class:makeGenericMap(self.args))
            end
        end
    end
    local table = self.scope.rt.mergeTables(fieldsTable)
    return table, true
end

-- 绑定变量的字段合并表
---@type Node.Table
M.variableTable = nil

---@param self Node.Call
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
M.value = nil

---@param self Node.Call
---@return Node
---@return true
M.__getter.value = function (self)
    self.value = self.scope.rt.NEVER
    local head = self.head
    head:addRef(self)
    ---@cast head Node.Type
    if not head:isComplex() then
        return self, true
    end
    if head:isClassLike() then
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
    if head:isAliasLike() then
        ---@type Node[]
        local aliases = {}
        ---@param alias Node.Alias
        for _, alias in ipairs(self.protoAliases) do
            if alias.value then
                aliases[#aliases+1] = alias.value:resolveGeneric(alias:makeGenericMap(self.args))
            end
        end
        local union = self.scope.rt.union(aliases)
        return union, true
    end
    return self, true
end

function M:simplify()
    if self.value == self then
        return self
    end
    return self.value:simplify()
end

---@param self Node.Call
---@return boolean
---@return true
M.__getter.hasGeneric = function (self)
    for _, arg in ipairs(self.args) do
        arg:addRef(self)
        if arg.hasGeneric then
            return true, true
        end
    end
    return false, true
end

function M:resolveGeneric(map)
    if not self.hasGeneric then
        return self
    end
    local args = ls.util.map(self.args, function (arg)
        return arg:resolveGeneric(map)
    end)
    return self.scope.rt.call(self.head.typeName, args)
end

function M:onView(viewer, options)
    return '{}<{}>' % {
        self.head.typeName,
        table.concat(ls.util.map(self.args, function (arg)
            return viewer:view(arg)
        end), ', '),
    }
end
