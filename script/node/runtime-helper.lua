---@class Node.Runtime
local M = Class 'Node.Runtime'

---@param node Node.Type | Node.Call
---@return Node.Class.ExtendAble[]
function M:calcFullExtends(node)
    ---@type Node.Class.ExtendAble[]
    local results = {}
    local visited = {}

    ---@param t Node.Type | Node.Call
    ---@param nextQueue (Node.Type | Node.Call)[]
    local function searchOnce(t, nextQueue)
        if visited[t] then
            return
        end
        visited[t] = true
        for _, ext in ipairs(t.extends) do
            results[#results+1] = ext
            if ext.kind == 'type'
            or ext.kind == 'call' then
                ---@cast ext -Node.Table
                nextQueue[#nextQueue+1] = ext
            end
        end
    end

    local queue = { node }
    while #queue > 0 do
        local nextQueue = {}
        for _, t in ipairs(queue) do
            searchOnce(t, nextQueue)
        end
        queue = nextQueue
    end

    for _, result in ipairs(results) do
        result:addRef(node)
    end

    return results
end

---@param params (Node?)[][]
---@param n integer
---@param packs? Node.List[]
---@return integer[]
function M:getBestMatchs(params, n, packs)
    local matchs = {}
    local feasible = {}
    if packs then
        local infeasible
        for i = 1, #params do
            local pack = packs[i]
            if pack and pack.max and n > pack.max then
                infeasible = infeasible or {}
                infeasible[#infeasible+1] = i
            else
                feasible[#feasible+1] = i
            end
        end
        if #feasible == 0 then
            feasible = infeasible
        end
    else
        for i = 1, #params do
            feasible[i] = i
        end
    end
    matchs = feasible

    ---@param a Node
    ---@param b Node
    ---@return boolean?
    local function isMoreExact(a, b)
        if a == b then
            return nil
        end
        if a == self.ANY then
            return false
        end
        if b == self.ANY then
            return true
        end
        local a2b = a >> b
        local b2a = b >> a
        if a2b == b2a then
            return nil
        end
        return a2b
    end

    local cannotDecide = {}
    table.sort(matchs, function (a, b)
        local paramsA = params[a]
        local paramsB = params[b]
        -- 参数数越接近实参数者优先（overload 优先于参数过多的 base）
        local da = math.abs((paramsA and #paramsA or 0) - n)
        local db = math.abs((paramsB and #paramsB or 0) - n)
        if da ~= db then
            return da < db
        end
        for i = 1, n do
            local moreExact = isMoreExact(paramsA[i] or self.ANY, paramsB[i] or self.ANY)
            if moreExact ~= nil then
                return moreExact
            end
        end
        cannotDecide[a] = true
        cannotDecide[b] = true
        return false
    end)

    local function isCannotDecideAll()
        for _, v in ipairs(matchs) do
            if not cannotDecide[v] then
                return false
            end
        end
        return true
    end

    if isCannotDecideAll() then
        table.sort(matchs)
        return matchs
    end

    local bestN = 1
    local bestI = matchs[1]
    local bestParams = params[bestI]

    local function isAllSame(paramsA, paramsB)
        for i = 1, n do
            if (paramsA[i] or self.ANY) ~= (paramsB[i] or self.ANY) then
                return false
            end
        end
        return true
    end

    for i = 2, #matchs do
        local currI = matchs[i]
        local currParams = params[currI]
        if isAllSame(bestParams, currParams) then
            bestN = bestN + 1
        else
            break
        end
    end

    for i = bestN + 1, #matchs do
        matchs[i] = nil
    end

    table.sort(matchs)

    return matchs
end

---@param parent Node
---@param key Node.Key
---@return Node.Field[]
function M:findFields(parent, key)
    local child = parent:get(key)

    ---@type Node.Field[]
    local results = {}

    ---@param node Node.Field
    child:each('field', function (node)
        results[#results+1] = node
    end)
    ---@param node Node.Variable
    child:each('variable', function (node)
        if self.luaKey(node.key) ~= self.luaKey(key) then
            return
        end
        if node:getLocation() then
            results[#results+1] = self.field(key):setLocation(node:getLocation())
        end
        for assign in node:eachAssign() do
            results[#results+1] = assign
        end
    end)

    return results
end

---@param key Node.Key
---@param ... Node.Key
---@return Node.Field[]
function M:findGlobalVariableFields(key, ...)
    local fields = {}
    local variable = self:globalGet(key, ...)
    if variable:getLocation() then
        fields[#fields+1] = self.field(key):setLocation(variable:getLocation())
    end
    for assign in variable:eachAssign() do
        fields[#fields+1] = assign
    end
    return fields
end

--- 根据 AST 节点反推期望类型：函数参数（paramOf）或赋值变量（variable）。
--- 按位置从 source 的父上下文反推，不经过共享 value 节点的 expectParent。
---@param source LuaParser.Node.Base
---@return Node?
function M:getExpectValue(source)
    local s = source
    while s.kind == 'paren' do
        ---@cast s LuaParser.Node.Paren
        s = s.value:trim()
    end
    local parent = s.parent
    if not parent then
        return nil
    end
    if parent.kind == 'call' then
        ---@cast parent LuaParser.Node.Call
        local funcNode = self.scope.vm:getVariable(parent.node)
                     or self.scope.vm:getNode(parent.node)
        if not funcNode then
            return nil
        end
        local index
        for i, arg in ipairs(parent.args) do
            if arg == s then
                index = i
                break
            end
        end
        if not index then
            return nil
        end
        if parent.node and parent.node.subtype == 'method' then
            index = index + 1
        end
        return self.paramOf(funcNode, index):getExpectValue()
    elseif parent.kind == 'localdef' then
        ---@cast parent LuaParser.Node.LocalDef
        if not parent.values then
            return nil
        end
        local index
        for i, value in ipairs(parent.values) do
            if value == s then
                index = i
                break
            end
        end
        if not index or not parent.vars[index] then
            return nil
        end
        local varNode = self.scope.vm:getVariable(parent.vars[index])
        if not varNode then
            return nil
        end
        return varNode:getExpectValue()
    elseif parent.kind == 'assign' then
        ---@cast parent LuaParser.Node.Assign
        if not parent.values then
            return nil
        end
        local index
        for i, value in ipairs(parent.values) do
            if value == s then
                index = i
                break
            end
        end
        if not index or not parent.exps[index] then
            return nil
        end
        local varNode = self.scope.vm:getVariable(parent.exps[index])
        if not varNode then
            return nil
        end
        return varNode:getExpectValue()
    end
    return nil
end
