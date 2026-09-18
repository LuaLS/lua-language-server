---@class Node.Intersection: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(scope: Scope, nodes?: Node[]): Node.Intersection
local M = ls.node.register 'Node.Intersection'

M.kind = 'intersection'
M.typeName = 'intersection'

---@param scope Scope
---@param nodes? Node[]
function M:__init(scope, nodes)
    self.scope = scope
    ---@type Node[]
    local values = {}

    if nodes then
        for _, v in ipairs(nodes) do
            if v.kind == 'intersection' then
                ---@cast v Node.Intersection
                ls.util.arrayMerge(values, v.rawNodes)
            else
                values[#values+1] = v
            end
        end

        ls.util.arrayRemoveDuplicate(values)
    end

    self.rawNodes = values
end

---@type Node[]
M.values = nil

---@type integer
local DEPTH_LIMIT = 64

---@type integer
local depth = 0

---@type table<Task, integer>
local taskDepths = ls.util.weakKTable()

---@type number
local lastOverflowLog = 0

---@type table<string, true>
local buildingValues = {}

---@type table<string, true>
local buildingHasGeneric = {}

---@param raw Node
---@return string
local function rawKey(raw)
    local kind = raw.kind
    if kind == 'variable' then
        ---@cast raw Node.Variable
        local key = raw.key
        return 'v:' .. tostring(type(key) == 'table' and key.literal or key)
    end
    if kind == 'call' then
        ---@cast raw Node.Call
        return 'c:' .. raw.head.typeName .. '/' .. #raw.args
    end
    return tostring(raw)
end

---@param nodes Node[]
---@return string
local function rawSignature(nodes)
    local parts = {}
    for i, raw in ipairs(nodes) do
        parts[i] = rawKey(raw)
    end
    table.sort(parts)
    return table.concat(parts, '|')
end

---@return Task?, integer
local function enterDepth()
    local task = ls.task.getCurrentTask()
    if not task then
        depth = depth + 1
        return nil, depth
    end
    local d = (taskDepths[task] or 0) + 1
    taskDepths[task] = d
    return task, d
end

---@param task Task?
---@param d integer
local function leaveDepth(task, d)
    if task then
        taskDepths[task] = d - 1
    else
        depth = d - 1
    end
end

---@param self Node.Intersection
---@return Node[]
---@return true
local function buildValues(self)
    local rt = self.scope.rt
    local values = {}
    local tables = {}
    local literalPart
    local basicTypePart

    for i, raw in ipairs(self.rawNodes) do
        raw:addRef(self)
        if raw.hasGeneric then
            goto continue
        end
        local union = raw:simplify()
        if union.kind == 'union' then
            ---@cast union Node.Union
            local newValues = {}
            for j, uv in ipairs(union.values) do
                local parts = {}
                table.move(self.rawNodes, 1, i - 1, 1, parts)
                parts[i] = uv
                table.move(self.rawNodes, i + 1, #self.rawNodes, i + 1, parts)
                local newValue = rt.intersection(parts)
                if newValue.value ~= rt.NEVER then
                    newValues[#newValues+1] = newValue
                end
            end
            return { rt.union(newValues) }, true
        end
        ::continue::
    end

    for _, raw in ipairs(self.rawNodes) do
        local value = raw:simplify()
        if value.kind == 'table' then
            tables[#tables+1] = value
        elseif value == rt.NIL then
            goto continue
        else
            values[#values+1] = value
            if value.kind == 'value' or value.kind == 'function' then
                if literalPart then
                    return {}, true
                end
                literalPart = value
            end
            ---@diagnostic disable-next-line: undefined-field
            if value.isBasicType then
                if basicTypePart then
                    return {}, true
                end
                basicTypePart = value
            end
        end
        ::continue::
    end

    if literalPart then
        if basicTypePart and not (literalPart >> basicTypePart) then
            return {}, true
        end
        for i, v in ipairs(values) do
            if literalPart ~= v and literalPart >> v then
                values[i] = false
            end
        end
    end

    for i, tbl in ipairs(tables) do
        for _, v in ipairs(values) do
            if  v.kind ~= 'generic'
            and v >> tbl then
                tables[i] = false
                break
            end
        end
    end

    local merged = {}
    for _, tbl in ipairs(tables) do
        if tbl then
            merged[#merged+1] = tbl
        end
    end
    for _, v in ipairs(values) do
        if v then
            merged[#merged+1] = v
        end
    end
    return merged, true
end

---@param self Node.Intersection
---@param what string
local function logOverflow(self, what)
    local clock = os.clock()
    if clock - lastOverflowLog <= 5 then
        return
    end
    lastOverflowLog = clock
    log.error('[Intersection] {}: {} raw node(s), sig={}' % {
        what, #self.rawNodes, rawSignature(self.rawNodes),
    })
end

---@param self Node.Intersection
---@return Node[]
---@return true
M.__getter.values = function (self)
    local signature = rawSignature(self.rawNodes)
    if buildingValues[signature] then
        logOverflow(self, 'values cycle detected')
        return {}, true
    end
    local task, d = enterDepth()
    if d > DEPTH_LIMIT then
        leaveDepth(task, d)
        logOverflow(self, 'values depth overflow (>64)')
        return { self.scope.rt.ANY }, true
    end
    buildingValues[signature] = true
    local values, isTrue = buildValues(self)
    buildingValues[signature] = nil
    leaveDepth(task, d)
    return values, isTrue
end

---@type Node
M.value = nil

---@param self Node.Intersection
---@return Node
---@return true
M.__getter.value = function (self)
    local rt = self.scope.rt
    self.value = rt.NEVER

    if #self.values == 0 then
        return rt.NEVER, true
    end
    if #self.values == 1 then
        return self.values[1], true
    end

    local tableParts = {}
    for _, value in ipairs(self.values) do
        if value.kind == 'table' then
            tableParts[#tableParts+1] = value
        elseif value.kind == 'tuple' then
            ---@cast value Node.Tuple
            local fields = {}
            for _, key in ipairs(value.keys) do
                if key.kind == 'value' then
                    fields[key] = value:get(key.literal)
                end
            end
            tableParts[#tableParts+1] = rt.table(fields)
        else
            self.otherParts[#self.otherParts+1] = value
        end
    end

    self.tablePart = rt.mergeTables(tableParts, function (oldValue, newValue)
        local field = rt.field(oldValue.key, oldValue.value & newValue.value)
        local location = oldValue.location or newValue.location
        if location then
            field.location = location
        end
        return field
    end)

    if #self.otherParts == 0 then
        return self.tablePart, true
    end

    return self, true
end

---@type Node.Table
M.tablePart = nil

---@param self Node.Intersection
---@return Node.Table
---@return true
M.__getter.tablePart = function (self)
    return self.scope.rt.table(), true
end

---@type Node[]
M.otherParts = nil

---@param self Node.Intersection
---@return Node[]
---@return true
M.__getter.otherParts = function (self)
    return {}, true
end

function M:get(key)
    if self.value ~= self then
        return self.value:get(key)
    end
    local result, exists = self.tablePart:get(key)
    for _, part in ipairs(self.otherParts) do
        if not part:isTableLike() then
            goto continue
        end
        local partValue, partExists = part:get(key)
        if not partExists then
            goto continue
        end
        if exists then
            result = result & partValue
        else
            result = partValue
            exists = true
        end
        ::continue::
    end
    return result, exists
end

---@param self Node.Intersection
---@return Node
---@return true
M.__getter.truthy = function (self)
    self.value:addRef(self)
    if self.value == self then
        return self, true
    end
    return self.value.truthy, true
end

---@param self Node.Intersection
---@return Node
---@return true
M.__getter.falsy = function (self)
    self.value:addRef(self)
    if self.value == self then
        return self.scope.rt.NEVER, true
    end
    return self.value.falsy, true
end

function M:onCanBeCast(other)
    return other.value:canCast(self.value)
end

function M:onCanCast(other)
    return self.value:canCast(other.value)
end

---@param self Node.Intersection
---@return boolean
---@return true
local function buildHasGeneric(self)
    if self.value == self then
        local hasGeneric = false
        for _, v in ipairs(self.rawNodes) do
            v:addRef(self)
            if v.hasGeneric then
                hasGeneric = true
            end
        end
        return hasGeneric, true
    else
        self.value:addRef(self)
        return self.value.hasGeneric, true
    end
end

---@param self Node.Intersection
---@return boolean
---@return true
M.__getter.hasGeneric = function (self)
    local signature = rawSignature(self.rawNodes)
    if buildingHasGeneric[signature] then
        logOverflow(self, 'hasGeneric cycle detected')
        return false, true
    end
    local task, d = enterDepth()
    if d > DEPTH_LIMIT then
        leaveDepth(task, d)
        logOverflow(self, 'hasGeneric depth overflow (>64)')
        return false, true
    end
    buildingHasGeneric[signature] = true
    local hasGeneric, isTrue = buildHasGeneric(self)
    buildingHasGeneric[signature] = nil
    leaveDepth(task, d)
    return hasGeneric, isTrue
end

---@param map table<Node.Generic, Node>
---@param ctx? Node.ResolveContext
---@return Node
function M:resolveGeneric(map, ctx)
    if self.value ~= self then
        return self.value:resolveGeneric(map, ctx)
    end
    if not self.hasGeneric then
        return self
    end
    ctx = ctx or ls.node.resolveContext()
    if ctx.visited[self] then
        return ctx.visited[self]
    end
    local newValues = {}
    for _, v in ipairs(self.rawNodes) do
        newValues[#newValues+1] = v:resolveGeneric(map, ctx)
    end
    local newInter = self.scope.rt.intersection(newValues)
    ctx.visited[self] = newInter
    return newInter
end

function M:inferGeneric(other, result)
    for _, v in ipairs(self.values) do
        v:inferGeneric(other, result)
    end
end

function M:each(kind, callback, visited)
    visited = ls.util.visited(self, visited)
    if not visited then
        return
    end
    local values = self.values
    for _, v in ipairs(values) do
        v:each(kind, callback, visited)
    end
end

function M:every(callback, visited)
    visited = ls.util.visited(self, visited)
    if not visited then
        return self
    end
    local newValues = {}
    for _, v in ipairs(self.values) do
        newValues[#newValues+1] = callback(v)
    end
    return self.scope.rt.intersection(newValues)
end

function M:onView(viewer, options)
    if self.value ~= self then
        return viewer:view(self.value, options)
    end
    local values = self.values
    if #values == 0 then
        return 'never'
    end
    if #values == 1 then
        return viewer:view(values[1], {
            skipLevel = 0,
            needParentheses = options.needParentheses,
        })
    end
    local elements = {}
    for _, value in ipairs(values) do
        local v = value
        if v.kind == 'variable' then
            v = v.value
        end
        if v.hideInUnionView then
            goto continue
        end
        local view = viewer:view(v, {
            needParentheses = true,
        })
        elements[#elements+1] = view
        ::continue::
    end
    local result = table.concat(elements, ' & ')
    if options.needParentheses then
        return '(' .. result .. ')'
    end
    return result
end
