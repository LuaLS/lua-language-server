local guide = require 'parser.guide'
local vm    = require 'vm'

local function asFunction(source)
    if not source.returns then
        return nil
    end
    local returns = {}
    for _, rtn in ipairs(source.returns) do
        for i = 1, #rtn do
            local values = vm.getValue(rtn[i])
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
            lines[i] = ('  -> %s'):format(vm.viewType(returns[i]))
        else
            lines[i] = ('% 3d. %s'):format(i, returns[i])
        end
    end
    return table.concat(lines, '\n')
end

return function (source)
    if source.type == 'function' then
        return asFunction(source)
    end
end
