---@class Node.Call: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(scope: Scope, head: string | Node, args: Node[]): Node.Call
local M = ls.node.register 'Node.Call'

M.kind = 'call'

---@type Node
M.head = nil

---@param scope Scope
---@param head string | Node
---@param args Node[]
function M:__init(scope, head, args)
    self.scope = scope
    if type(head) == 'string' then
        self.head = scope.node.type(head)
    else
        self.head = head
    end
    self.args = args

    for i, arg in ipairs(self.args) do
        if arg.kind == 'variable' then
            self.args[i] = arg.value
        end
    end

    self.head:registerFlushChain(self)
end

--- 获取我的继承
---@type Node.Class.ExtendAble[]
M.extends = nil

---@param self Node.Call
---@return Node.Class.ExtendAble[]
---@return true
M.__getter.extends = function (self)
    local results = {}
    local head = self.head
    if head.kind ~= 'type' then
        return results, true
    end
    ---@cast head Node.Type
    for _, class in ipairs(head:getProtoClassesWithNParams(#self.args)) do
        if class.extends then
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
    return ls.node.calcFullExtends(self), true
end

--- 所有继承的合并表
---@type Node.Table
M.extendsTable = nil

---@param self Node.Call
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
    table:addChilds(tables)

    return table, true
end

--- 类型自身的字段（一般是通过 ---@field 添加）
---@type Node.Table
M.table = nil

---@param self Node.Call
---@return Node.Table
---@return true
M.__getter.table = function (self)
    local table = self.scope.node.table()
    local head = self.head
    if head.kind ~= 'type' then
        return table, true
    end
    ---@cast head Node.Type
    if head.classes then
        local fields = {}
        for _, class in ipairs(head:getProtoClassesWithNParams(#self.args)) do
            if class.fields then
                fields[#fields+1] = class.fields:resolveGeneric(class:makeGenericMap(self.args))
            end
        end
        table:addChilds(fields)
    end
    return table, true
end

---@type Node
M.value = nil

---@param self Node.Call
---@return Node
---@return true
M.__getter.value = function (self)
    self.value = self.scope.node.NEVER
    local head = self.head
    if head.kind == 'type' then
        return self:getTypeValue(), true
    else
        return self.returns:get(1), true
    end
end

---@return Node
function M:getTypeValue()
    local head = self.head
    ---@cast head Node.Type
    if not head:isComplex() then
        return self
    end
    if head:isClassLike() then
        local merging = {}
        -- 1. 直接写在 class 里的字段
        merging[#merging+1] = self.table
        -- 2. 绑定的变量里的字段
        for _, class in ipairs(head:getProtoClassesWithNParams(#self.args)) do
            if class.variables then
                for variable in class.variables:pairsFast() do
                    ---@cast variable Node.Variable
                    merging[#merging+1] = variable.fields
                end
            end
        end
        -- 3. 继承来的字段
        if not self.extendsTable:isEmpty() then
            merging[#merging+1] = self.extendsTable
        end

        if #merging == 1 then
            return merging[1]
        end

        local value = self.scope.node.table()
        value:addChilds(merging)
        return value
    end
    if head:isAliasLike() then
        ---@type Node[]
        local aliases = {}
        ---@param alias Node.Alias
        for _, alias in ipairs(head:getProtoAliasesWithNParams(#self.args)) do
            if alias.value then
                aliases[#aliases+1] = alias.value:resolveGeneric(alias:makeGenericMap(self.args))
            end
        end
        local union = self.scope.node.union(aliases)
        return union.value
    end
    return self
end

---@type Node
M.returns = nil

---@param self Node.Call
---@return Node
---@return true
M.__getter.returns = function (self)
    local returns = {}
    local allMin = 0
    ---@type integer?
    local allMax = 0
    local hasDef

    local node = self.scope.node

    for f in self.head:finalValue():each 'function' do
        hasDef = true
        ---@cast f Node.Function
        f = f:resolveGeneric(f:makeGenericMap(self.args))
        local min, max = f:getReturnCount()
        for i = 1, min do
            returns[i] = returns[i] | f:getReturn(i)
        end
        if not allMin or allMin > min then
            allMin = min
        end
        if not max then
            allMax = nil
        elseif allMax and allMax < max then
            allMax = max
        end
    end

    if not hasDef then
        return node.UNKNOWN, true
    end

    local vararg = node.vararg(returns, allMin, allMax)
    return vararg, true
end

function M:resolveGeneric(map)
    local args = ls.util.map(self.args, function (arg)
        return arg:resolveGeneric(map)
    end)
    return self.scope.node.call(self.head.typeName, args)
end

ls.node.registerView('call', function(viewer, node)
    ---@cast node Node.Call
    return '{}<{}>' % {
        node.head.typeName,
        table.concat(ls.util.map(node.args, function (arg)
            return viewer:view(arg)
        end), ', '),
    }
end)
