---@class Node.Call: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(scope: Scope, name: string, args: Node[]): Node.Call
local M = ls.node.register 'Node.Call'

M.kind = 'call'

---@param scope Scope
---@param name string
---@param args Node[]
function M:__init(scope, name, args)
    self.scope = scope
    self.head = scope.node.type(name)
    self.args = args

    self.head:flushMe(self, true)
end

--- 获取所有继承（广度优先）
---@type (Node.Type | Node.Table)[]
M.fullExtends = nil

---@param self Node.Call
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
        for _, class in ipairs(t:getProtoClassesWithNParams(#self.args)) do
            if class.extends then
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

    search { self.head }

    return result, true
end

--- 所有继承的合并表
---@type Node.Table
M.extendsTable = nil

---@param self Node.Call
---@return Node.Table
---@return true
M.__getter.extendsTable = function (self)
    local table = self.scope.node.table()
    if #self.head.fullExtends == 0 then
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

---@param self Node.Call
---@return Node.Table
---@return true
M.__getter.table = function (self)
    local table = self.scope.node.table()
    if self.head.classes then
        local fields = ls.util.map(self.head:getProtoClassesWithNParams(#self.args), function (class)
            return class.fields
        end)
        table:extends(fields)
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
    if not self.head:isComplex() then
        return self, true
    end
    if self.head:isClassLike() then
        local merging = {}
        -- 1. 直接写在 class 里的字段
        merging[#merging+1] = self.table
        -- 2. 绑定的变量里的字段
        for _, class in ipairs(self.head:getProtoClassesWithNParams(#self.args)) do
            if class.variables then
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
    if self.head:isAliasLike() then
        ---@type Node[]
        local aliases = {}
        ---@param alias Node.Alias
        for _, alias in ipairs(self.head:getProtoAliasesWithNParams(#self.args)) do
            if alias.extends then
                ls.util.arrayMerge(aliases, alias.extends)
            end
        end
        local union = self.scope.node.union(aliases)
        return union.value, true
    end
    return self, true
end

function M:resolveGeneric(map)
    local args = ls.util.map(self.args, function (arg)
        return arg:resolveGeneric(map)
    end)
    return self.scope.node.call(self.head.typeName, args)
end

function M:view(skipLevel)
    return string.format('%s<%s>'
        , self.head.typeName
        , table.concat(ls.util.map(self.args, function (arg, i)
            return arg:view(skipLevel)
        end), ', ')
    )
end
