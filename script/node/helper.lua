---@param node Node.Type | Node.Call
---@return Node.Class.ExtendAble[]
function ls.node.calcFullExtends(node)
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

    return results
end
