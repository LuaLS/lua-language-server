local guide = require 'parser.guide'
local vm    = require 'vm'

local function asFunction(source)
    if not source.args then
        return ''
    end
    local args = {}
    for i = 1, #source.args do
        local arg = source.args[i]
        local name = arg.name or guide.getName(arg)
        if name then
            args[i] = ('%s: %s'):format(name, vm.getType(arg))
        else
            args[i] = ('%s'):format(vm.getType(arg))
        end
    end
    return table.concat(args, ', ')
end

return function (source)
    if source.type == 'function' then
        return asFunction(source)
    end
end
