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
---@return integer[]
function M:getBestMatchs(params, n)
    local matchs = {}
    for i = 1, #params do
        matchs[i] = i
    end

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

    table.sort(matchs, function (a, b)
        local paramsA = params[a]
        local paramsB = params[b]
        for i = 1, n do
            local moreExact = isMoreExact(paramsA[i] or self.ANY, paramsB[i] or self.ANY)
            if moreExact ~= nil then
                return moreExact
            end
        end
        return false
    end)

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
        if node.location then
            results[#results+1] = self.field(key):setLocation(node.location)
        end
        if node.assigns then
            for assign in node.assigns:pairsFast() do
                ---@cast assign Node.Field
                results[#results+1] = assign
            end
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
    if variable.location then
        fields[#fields+1] = self.field(key):setLocation(variable.location)
    end
    if variable.assigns then
        for assign in variable.assigns:pairsFast() do
            ---@cast assign Node.Field
            fields[#fields+1] = assign
        end
    end
    return fields
end
