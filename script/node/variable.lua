---@class Node.Variable: Node
local M = ls.node.register 'Node.Variable'

M.kind = 'variable'

M.hideInUnionView = true
---@type Node.Variable?
M.masterVariable = nil

---@alias Node.Key string | number | boolean | Node

---@type Node
M.key = nil

---@param scope Scope
---@param name Node.Key
---@param parent? Node.Variable
function M:__init(scope, name, parent)
    if type(name) == 'table' then
        ---@cast name Node
        self.key = name
    else
        ---@cast name -Node
        self.key = scope.rt.value(name)
    end
    self.scope = scope
    self.parent = parent
end

---@type Node.Location?
M.location = nil

---@param location Node.Location
---@return self
function M:setLocation(location)
    self.location = location
    return self
end

---@type LinkedTable
M.types = nil

---@param node Node
---@return Node.Variable
function M:addType(node)
    if self.masterVariable then
        self.masterVariable:addType(node)
        return self
    end
    if not self.types then
        self.types = ls.tools.linkedTable.create()
    end
    self.types:pushTail(node)
    self:flushCache()

    return self
end

---@param node Node
---@return Node.Variable
function M:removeType(node)
    if self.masterVariable then
        self.masterVariable:removeType(node)
        return self
    end
    if not self.types then
        return self
    end
    self.types:pop(node)
    if self.types:getSize() == 0 then
        self.types = nil
    end
    self:flushCache()

    return self
end

---@type LinkedTable
M.assigns = nil

---@param field Node.Field
---@return Node.Variable
function M:addAssign(field)
    if self.masterVariable then
        self.masterVariable:addAssign(field)
        return self
    end
    if not self.assigns then
        self.assigns = ls.tools.linkedTable.create()
    end
    self.assigns:pushTail(field)

    self:flushCache()

    return self
end

---@param field Node.Field
---@return Node.Variable
function M:removeAssign(field)
    if self.masterVariable then
        self.masterVariable:removeAssign(field)
        return self
    end
    if not self.assigns then
        return self
    end
    self.assigns:pop(field)

    if self.assigns:getSize() == 0 then
        self.assigns = nil

        local parent = self.parent
        for _ = 1, 100 do
            if not parent then
                break
            end
            parent.childs[self.key] = nil
            if not next(parent.childs) then
                parent.childs = nil
                parent = parent.parent
            else
                break
            end
        end
    end
    self:flushCache()

    return self
end

---@type LinkedTable
M.classes = nil

---@param node Node.Class
---@return Node.Variable
function M:addClass(node)
    if self.masterVariable then
        self.masterVariable:addClass(node)
        return self
    end
    if not self.classes then
        self.classes = ls.tools.linkedTable.create()
    end
    self.classes:pushTail(node)
    self:flushCache()

    return self
end

---@param node Node.Class
---@return Node.Variable
function M:removeClass(node)
    if self.masterVariable then
        self.masterVariable:removeClass(node)
        return self
    end
    if not self.classes then
        return self
    end
    self.classes:pop(node)
    if self.classes:getSize() == 0 then
        self.classes = nil
    end
    self:flushCache()

    return self
end

---@param var Node.Variable
function M:setMasterVariable(var)
    if self == var or self.masterVariable then
        error('Cannot set master variable')
    end
    self.masterVariable = var.masterVariable or var
    self.masterVariable:addRef(self)

    self:flushCache()
end

---@type Node|false
M.classValue = nil

---@param self Node.Variable
---@return Node|false
---@return true
M.__getter.classValue = function (self)
    if self.masterVariable then
        return self.masterVariable.classValue, true
    end
    if not self.classes then
        return false, true
    end
    local rt = self.scope.rt
    local union = rt.union(ls.util.map(self.classes:toArray(), function (v)
        ---@cast v Node.Class
        return v.masterType
    end))
    union:addRef(self)
    return union, true
end

---@type Node|false
M.typeValue = nil

---@param self Node.Variable
---@return Node|false
---@return true
M.__getter.typeValue = function (self)
    if self.masterVariable then
        return self.masterVariable.typeValue, true
    end
    if not self.types then
        return false, true
    end
    local rt = self.scope.rt
    local union = rt.union(self.types:toArray())
    union:addRef(self)
    return union, true
end

---@type Node|false
M.parentExpectValue = nil

---@param self Node.Variable
---@return Node|false
---@return true?
M.__getter.parentExpectValue = function (self)
    if self.masterVariable then
        return self.masterVariable.parentExpectValue
    end
    local parent = self.parent
    if not parent then
        return false, true
    end
    parent:addRef(self)
    return parent:getExpect(self.key) or false, true
end

-- 仅包含自身显式赋值，以及赋值一张字面量表所产生的字段
---@type Node.Table|false
M.fields = nil

---@param self Node.Variable
---@return Node.Table|false
---@return true
M.__getter.fields = function (self)
    if self.masterVariable then
        return self.masterVariable.fields, true
    end
    local childs = {}
    if self.assigns then
        for assign in self.assigns:pairsFast() do
            ---@cast assign Node.Field
            if assign.value and assign.value.kind == 'table' then
                childs[#childs+1] = assign.value
                assign.value:addRef(self)
            end
        end
    end
    if self.childsValue then
        childs[#childs+1] = self.childsValue
    end

    if #childs == 0 then
        return false, true
    end
    if #childs == 1 then
        return childs[1], true
    end

    local t = self.scope.rt.table()
    t:addChilds(childs)
    return t, true
end

---@type table<Node, Node.Variable>?
M.childs = nil

---@param key1 Node.Key
---@param key2? Node.Key
---@param ... Node.Key
---@return Node.Variable
function M:getChild(key1, key2, ...)
    if self.masterVariable then
        return self.masterVariable:getChild(key1, key2, ...)
    end
    local rt = self.scope.rt
    local key = key1
    local path
    if key2 then
        path = { key1, key2, ... }
        key = path[#path]
        path[#path] = nil
    end
    local current = self
    if path then
        for _, k in ipairs(path) do
            if type(k) ~= 'table' then
                ---@cast k -Node
                k = rt.value(k)
            end
            local child = current.childs and current.childs[k]
            if not child then
                child = rt.variable(k, current)
                current.childs = current.childs or {}
                current.childs[k] = child
            end
            current = child
        end
    end
    if type(key) ~= 'table' then
        ---@cast key -Node
        key = rt.value(key)
    end
    local child = current.childs and current.childs[key]
    if not child then
        child = rt.variable(key, current)
        current.childs = current.childs or {}
        current.childs[key] = child
    end
    return child
end

---@param field Node.Field
---@param path? Node.Key[]
---@return Node.Variable
function M:addField(field, path)
    if self.masterVariable then
        self.masterVariable:addField(field, path)
        return self
    end
    local rt = self.scope.rt
    local current = self
    if not current.childs then
        current.childs = {}
    end

    if path then
        for _, k in ipairs(path) do
            if type(k) ~= 'table' then
                ---@cast k -Node
                k = rt.value(k)
            end
            if not current.childs[k] then
                current.childs[k] = rt.variable(k, current)
            end
            current = current.childs[k]
            if not current.childs then
                current.childs = {}
            end
        end
    end

    if not current.childs[field.key] then
        current.childs[field.key] = rt.variable(field.key, current)
    end
    current = current.childs[field.key]
    if field.value then
        current:addAssign(field)
    end
    current.parent:flushCache()

    return current
end

---@param key Node.Key
---@return Node
---@return boolean exists
function M:get(key)
    if self.masterVariable then
        return self.masterVariable:get(key)
    end
    local rt = self.scope.rt
    if type(key) ~= 'table' then
        ---@cast key -Node
        key = rt.value(key)
    end
    return self.value:get(key)
end

---@param key string|number|boolean|Node
---@return Node?
function M:getExpect(key)
    if self.masterVariable then
        return self.masterVariable:getExpect(key)
    end
    if self.parentExpectValue then
        local r, e = self.parentExpectValue:get(key)
        return e and r or nil
    end
    local rt = self.scope.rt
    if self.classes then
        local expectValue = rt.union(ls.util.map(self.classes:toArray(), function (v)
            ---@cast v Node.Class
            return v.masterType.expectValue
        end))
        local r, e = expectValue:get(key)
        return e and r or nil
    end
    if self.types then
        local expectValue = rt.union(ls.util.map(self.types:toArray(), function (v)
            if v.kind == 'type' then
                ---@cast v Node.Type
                return v.expectValue
            end
            return v
        end))
        local r, e = expectValue:get(key)
        return e and r or nil
    end
    return nil
end

---@param key Node.Key
---@param variable Node.Variable
---@return Node.Variable
function M:setChild(key, variable)
    if self.masterVariable then
        self.masterVariable:setChild(key, variable)
        return self
    end
    if type(key) ~= 'table' then
        ---@cast key -Node
        key = self.scope.rt.value(key)
    end
    if not self.childs then
        self.childs = {}
    end
    self.childs[key] = variable
    self:flushCache()
    return self
end

---@param field Node.Field
---@param path? Node.Key[]
---@return Node.Variable
function M:removeField(field, path)
    if self.masterVariable then
        self.masterVariable:removeField(field, path)
        return self
    end
    if not self.childs then
        return self
    end
    ---@type Node.Variable
    local current = self
    if not current.childs then
        return self
    end

    local rt = self.scope.rt
    if path then
        for _, k in ipairs(path) do
            if type(k) ~= 'table' then
                ---@cast k -Node
                k = rt.value(k)
            end
            ---@type Node.Variable
            current = current.childs[k]
            if not current or not current.childs then
                return self
            end
        end
    end

    current = current.childs[field.key]
    if not current then
        return self
    end
    current:removeAssign(field)
    current.parent:flushCache()

    return current
end

---@type Node
M.value = nil

---@param self Node.Variable
---@return Node
---@return true
M.__getter.value = function (self)
    if self.masterVariable then
        return self.masterVariable.value, true
    end
    local rt = self.scope.rt
    return self.classValue
        or self.parentExpectValue
        or self.typeValue
        or self.equivalentValue
        or rt.UNKNOWN
        , true
end

---所有的等价对象（递归）
    ---@type (Node.Variable | Node.Field)[]
M.allEquivalents = nil

---@param self Node.Variable
---@return (Node.Variable | Node.Field)[]
---@return true
M.__getter.allEquivalents = function (self)
    if self.masterVariable then
        return self.masterVariable.allEquivalents, true
    end
    ---@type (Node.Variable | Node.Field)[]
    local results = {}
    local visited = {}

    ---@param var Node.Variable
    local function lookIntoVariable(var)
        if visited[var] then
            return
        end
        visited[var] = true
        results[#results+1] = var
        if not var.assigns then
            return
        end
        for assign in var.assigns:pairsFast() do
            ---@cast assign Node.Field
            local value = assign.value
            if not value then
                goto continue
            end
            local subVar = value:findValue { 'variable' }
            if subVar then
                ---@cast subVar Node.Variable
                lookIntoVariable(subVar)
            end
            ::continue::
        end
    end

    lookIntoVariable(self)

    ---@param value Node.Table
    local function lookIntoTable(value)
        if visited[value] then
            return
        end
        visited[value] = true
        local child = value.fieldMap[self.key]
        if not child then
            return
        end
        value:addRef(self)
        if #child > 0 then
            ls.util.arrayMerge(results, child)
        else
            results[#results+1] = child
        end
    end

    local parent = self.parent
    if parent then
        for _, equivalent in ipairs(parent.allEquivalents) do
            if equivalent.kind == 'variable' then
                ---@cast equivalent Node.Variable
                local child = equivalent.childs and equivalent.childs[self.key]
                if child and child ~= self then
                    results[#results+1] = child
                    equivalent:addRef(self)
                end
                if equivalent.assigns then
                    for assign in equivalent.assigns:pairsFast() do
                        ---@cast assign Node.Field
                        local value = assign.value
                        if value then
                            local t = value:findValue { 'type', 'table' }
                            if t and t.kind == 'table' then
                                ---@cast t Node.Table
                                lookIntoTable(t)
                            end
                        end
                    end
                end
            else
                ---@cast equivalent Node.Field
                if equivalent.value then
                    local t = equivalent.value:findValue { 'type', 'table' }
                    if t and t.kind == 'table' then
                        ---@cast t Node.Table
                        lookIntoTable(t)
                    end
                end
            end
        end
    end
    ls.util.arrayRemoveDuplicate(results)
    return results, true
end

-- 从等价物上获取所有的值
---@type Node
M.equivalentValue = nil

---@param self Node.Variable
---@return Node
---@return true
M.__getter.equivalentValue = function (self)
    if self.masterVariable then
        return self.masterVariable.equivalentValue, true
    end
    local rt = self.scope.rt
    ---@type Node[]
    local results = {}
    for _, equivalent in ipairs(self.allEquivalents) do
        if equivalent.kind == 'variable' then
            ---@cast equivalent Node.Variable
            if equivalent.assigns then
                equivalent:addRef(self)
                for assign in equivalent.assigns:pairsFast() do
                    ---@cast assign Node.Field
                    if assign.value then
                        results[#results+1] = assign.value
                    end
                end
            end
            if equivalent.childsValue then
                results[#results+1] = equivalent.childsValue
            end
        else
            ---@cast equivalent Node.Field
            if equivalent.value then
                results[#results+1] = equivalent.value
                equivalent.value:addRef(self)
            end
        end
    end

    -- 尽量合并表的字段
    local hasTable = false
    local tableParts = {}
    local unionResults = {}
    local hasType = false
    for _, node in ipairs(results) do
        local t = node:findValue {'table', 'type'}
        if t then
            if t.kind == 'table' then
                hasTable = true
                ---@cast t Node.Table
                if t.fields then
                    tableParts[#tableParts+1] = t
                end
            end
            if t.kind == 'type' then
                ---@cast t Node.Type
                if not t.isBasicType then
                    hasType = true
                end
                unionResults[#unionResults+1] = t
            end
        else
            unionResults[#unionResults+1] = node
        end
    end

    ls.util.arrayRemoveDuplicate(tableParts)

    if not hasType and #tableParts > 0 then
        if #tableParts == 1 then
            unionResults[#unionResults+1] = tableParts[1]
        else
            local tableNode = rt.table()
            tableNode:addChilds(tableParts)
            unionResults[#unionResults+1] = tableNode
        end
    end

    local result = #unionResults > 0 and rt.union(unionResults)
    if result then
        return result, true
    end
    if hasTable then
        return rt.table(), true
    else
        return rt.UNKNOWN, true
    end
end

---@return Node.Location[]
function M:getEquivalentLocations()
    ---@type Node.Location[]
    local locations = {}
    for _, equivalent in ipairs(self.allEquivalents) do
        if equivalent.kind == 'variable' then
            ---@cast equivalent Node.Variable
            locations[#locations+1] = equivalent.location
            if equivalent.assigns then
                for assign in equivalent.assigns:pairsFast() do
                    ---@cast assign Node.Field
                    locations[#locations+1] = assign.location
                end
            end
        else
            ---@cast equivalent Node.Field
            locations[#locations+1] = equivalent.location
        end
    end
    ls.util.arrayRemoveDuplicate(locations)
    return locations
end

---@type Node.Table|false
M.childsValue = nil

---@param self Node.Variable
---@return Node.Table|false
---@return true
M.__getter.childsValue = function (self)
    if self.masterVariable then
        return self.masterVariable.childsValue, true
    end
    local rt = self.scope.rt
    if not self.childs then
        return false, true
    end
    local fields = {}
    for key, var in pairs(self.childs) do
        var:addRef(self)
        if var.assigns or var.childs then
            fields[#fields+1] = {
                key   = key,
                value = var,
            }
        end
    end
    if #fields == 0 then
        return false, true
    end
    local table = rt.table()
    for _, field in ipairs(fields) do
        table:addField(field)
    end
    return table, true
end

---@private
M._hideAtHead = false

---@return Node.Variable
function M:hideAtHead()
    self._hideAtHead = true
    return self
end

---@param viewer Node.Viewer
---@param options Node.Viewer.Options
---@return string
function M:onViewAsVariable(viewer, options)
    ---@type Node.Variable[]
    local path = {}
    local current = self
    local tooLong
    while current do
        path[#path+1] = current
        current = current.parent
        if #path >= 8 then
            tooLong = true
            break
        end
    end
    if not tooLong then
        for i = #path, 2, -1 do
            local var = path[i]
            if var._hideAtHead then
                path[i] = nil
            else
                break
            end
        end
    end

    local views = {}
    if tooLong then
        views[#views+1] = '...'
    end
    views[#views+1] = viewer:viewAsKey(path[#path].key, {
        skipLevel = options.skipLevel,
    })
    for i = #path - 1, 1, -1 do
        local var = path[i]
        local view = viewer:viewAsKey(var.key, {
            skipLevel = options.skipLevel,
        })
        if view:sub(1, 1) ~= '[' then
            view = '.' .. view
        end
        views[#views+1] = view
    end

    return table.concat(views)
end

---@param other Node
---@return boolean
function M:onCanBeCast(other)
    return other:canCast(self.value)
end

---@param other Node
---@return boolean
function M:onCanCast(other)
    return self.value:canCast(other)
end
