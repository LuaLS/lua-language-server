local guide = require 'parser.guide'
local vm    = require 'vm'

local function mergeTypes(returns)
    if type(returns) == 'string' then
        return returns
    end
    local types = {}
    for _, rtn in ipairs(returns) do
        types[#types+1] = rtn.type
    end
    return guide.mergeTypes(types)
end

local function asLibrary(source)
    if not source.returns then
        return nil
    end
    local returns = {}
    for _, rtn in ipairs(source.returns) do
        local name = rtn.name
        local tp = rtn.type or 'any'
        if name then
            returns[#returns+1] = ('%s: %s'):format(name, tp)
        else
            returns[#returns+1] = tp
        end
    end
    if #returns == 0 then
        return nil
    end
    local lines = {}
    for i = 1, #returns do
        if i == 1 then
            lines[i] = ('  -> %s'):format(mergeTypes(returns[i]))
        else
            lines[i] = ('% 3d. %s'):format(i, mergeTypes(returns[i]))
        end
    end
    return table.concat(lines, '\n')
end

local function asFunction(source)
    if not source.returns then
        return nil
    end
    local returns = {}
    for _, rtn in ipairs(source.returns) do
        for i = 1, #rtn do
            local values = vm.getInfers(rtn[i])
            returns[#returns+1] = values
        end
        break
    end
    if #returns == 0 then
        return nil
    end
    local lines = {}
    for i = 1, #returns do
        if i == 1 then
            lines[i] = ('  -> %s'):format(mergeTypes(returns[i]))
        else
            lines[i] = ('% 3d. %s'):format(i, mergeTypes(returns[i]))
        end
    end
    return table.concat(lines, '\n')
end

return function (source)
    if source.library then
        return asLibrary(source)
    end
    if source.type == 'function' then
        return asFunction(source)
    end
end
