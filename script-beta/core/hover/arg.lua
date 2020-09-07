local guide = require 'parser.guide'
local vm    = require 'vm'

local function mergeTypesInLibrary(types)
    if type(types) == 'table' then
        return table.concat(types, '|')
    else
        return types or 'any'
    end
end

local function asLibrary(source, oop)
    if not source.args then
        return ''
    end
    local args = {}
    for i = 1, #source.args do
        local arg = source.args[i]
        local name = arg.name
        if name then
            args[i] = ('%s: %s'):format(name, mergeTypesInLibrary(arg.type))
        else
            args[i] = ('%s'):format(mergeTypesInLibrary(arg.type))
        end
    end
    local methodDef
    local parent = source.parent
    if parent and parent.type == 'setmethod' then
        methodDef = true
    end
    if not methodDef and oop then
        return table.concat(args, ', ', 2)
    else
        return table.concat(args, ', ')
    end
end

local function asFunction(source, oop)
    if not source.args then
        return ''
    end
    local args = {}
    for i = 1, #source.args do
        local arg = source.args[i]
        local name = arg.name or guide.getName(arg)
        if name then
            args[i] = ('%s: %s'):format(name, vm.getInferType(arg))
        else
            args[i] = ('%s'):format(vm.getInferType(arg))
        end
    end
    local methodDef
    local parent = source.parent
    if parent and parent.type == 'setmethod' then
        methodDef = true
    end
    if not methodDef and oop then
        return table.concat(args, ', ', 2)
    else
        return table.concat(args, ', ')
    end
end

return function (source, oop)
    if source.type == 'library' then
        return asLibrary(source.value, oop)
    elseif source.library then
        return asLibrary(source, oop)
    end
    if source.type == 'function' then
        return asFunction(source, oop)
    end
    return ''
end
