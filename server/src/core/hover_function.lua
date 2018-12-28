local function buildValueArgs(func, oo, select)
    local names = {}
    local values = {}
    if func.args then
        for i, arg in ipairs(func.args) do
            names[i] = arg.key
        end
    end
    if func.argValues then
        for i, value in ipairs(func.argValues) do
            values[i] = value.type
        end
    end
    local strs = {}
    local argLabel
    local start = 1
    if oo then
        start = 2
        if select then
            select = select + 1
        end
    end
    local max
    if func.built then
        max = #names
    else
        max = math.max(#names, #values)
    end
    for i = start, max do
        local name = names[i]
        local value = values[i] or 'any'
        if name then
            strs[#strs+1] = name .. ': ' .. value
        else
            strs[#strs+1] = value
        end
        if i == select then
            argLabel = strs[#strs]
        end
    end
    if func.hasDots then
        strs[#strs+1] = '...'
    end
    return table.concat(strs, ', '), argLabel
end

local function buildValueReturns(func)
    if not func.hasReturn then
        return ''
    end
    local strs = {}
    if func.returns then
        for i, rtn in ipairs(func.returns) do
            strs[i] = rtn.type
        end
    end
    if #strs == 0 then
        strs[1] = 'any'
    end
    return '\n  -> ' .. table.concat(strs, ', ')
end

return function (name, func, oo, select)
    local args, argLabel = buildValueArgs(func, oo, select)
    local returns = buildValueReturns(func)
    local title = ('function %s(%s)%s'):format(name, args, returns)
    return {
        label = title,
        argLabel = argLabel,
    }
end
