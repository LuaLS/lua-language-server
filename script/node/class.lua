---@class Node.Class: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(name: string): Node.Class
local M = ls.node.register 'Node.Class'

M.kind = 'class'

---@param scope Scope
---@param name string
---@param params? Node.Generic[]
---@param extends? Node[]
function M:__init(scope, name, params, extends)
    self.className = name
    self.scope = scope
    self.params = params
    self.extends = extends
end

--- 所有使用 ---@field 定义的字段
---@type Node.Table?
M.fields = nil

--- 添加字段（使用 ---@field 定义的字段）
---@param field Node.Field
---@return Node.Class
function M:addField(field)
    if not self.fields then
        self.fields = self.scope.node.table()
    end
    self.fields:addField(field)
    self:flushCache()
    return self
end

---@param field Node.Field
---@return Node.Class
function M:removeField(field)
    if not self.fields then
        return self
    end
    self.fields:removeField(field)
    if self.fields:isEmpty() then
        self.fields = nil
    end
    self:flushCache()
    return self
end

---@type Node.Location?
M.location = nil

---@param location Node.Location
function M:setLocation(location)
    self.location = location
end

--- 添加绑定的变量
---@param variable Node.Variable
---@return Node.Class
function M:addVariable(variable)
    if not self.variables then
        self.variables = ls.linkedTable.create()
    end

    self.variables:pushTail(variable)

    variable:flushMe(self, true)
    self:flushCache()

    return self
end

function M:get(key)
    if self.value == self then
        return self.scope.node.NEVER
    end
    return self.value:get(key)
end

--- 所有绑定的变量
---@type LinkedTable?
M.variables = nil

---@param variable Node.Variable
---@return Node.Class
function M:removeVariable(variable)
    if not self.variables then
        return self
    end
    self.variables:pop(variable)
    if self.variables:getSize() == 0 then
        self.variables = nil
    end

    variable:flushMe(self, false)
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

---@type Node
M.value = nil

---@param self Node.Class
---@return Node
---@return true
M.__getter.value = function (self)
    local value = self.scope.node.table()
    self.value = value

    local merging = {}
    -- 1. 使用 ---@field 定义的字段
    merging[#merging+1] = self.fields
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

    value:extends(merging)
    return value, true
end

function M:view(skipLevel)
    if self.params then
        return '{}<{}>' % {
            self.className,
            table.concat(ls.util.map(self.params, function (param)
                return param:view(skipLevel)
            end), ', '),
        }
    else
        return self.className
    end
end

---@param self Node.Class
---@return boolean
---@return true
M.__getter.hasGeneric = function (self)
    return self.params ~= nil, true
end

---@param map table<Node.Generic, Node>
---@return Node
function M:resolveGeneric(map)
    if not self.params then
        return self
    end
    return self.value:resolveGeneric(map)
end
