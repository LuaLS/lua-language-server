local guide = require 'parser.guide'
local vm    = require 'vm'

local function asFunction(source, caller)
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
    local methodDef, methodCall
    local parent = source.parent
    if parent and parent.type == 'setmethod' then
        methodDef = true
    end
    if caller then
        if caller.type == 'method'
        or caller.type == 'getmethod'
        or caller.type == 'setmethod' then
            methodCall = true
        end
    end
    if not methodDef and methodCall then
        return table.concat(args, ', ', 2)
    else
        return table.concat(args, ', ')
    end
end

return function (source, caller)
    if source.type == 'function' then
        return asFunction(source, caller)
    end
end
