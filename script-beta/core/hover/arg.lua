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
    local start = 1
    local methodDef
    local parent = source.parent
    if parent and parent.type == 'setmethod' then
        methodDef = true
    end
    if not methodDef and oop then
        start = 2
    end
    local args = {}
    local afterCount = 0
    for i = start, #source.args do
        local buf = {}
        local arg = source.args[i]
        local name = arg.name
        if arg.optional then
            if i == start then
                buf[#buf+1] = '['
            else
                buf[#buf+1] = ' ['
            end
        end
        if i > start then
            buf[#buf+1] = ', '
        end
        if name then
            buf[#buf+1] = ('%s: %s'):format(name, mergeTypesInLibrary(arg.type))
        else
            buf[#buf+1] = ('%s'):format(mergeTypesInLibrary(arg.type))
        end
        if arg.optional == 'after' then
            afterCount = afterCount + 1
        elseif arg.optional == 'self' then
            buf[#buf+1] = ']'
        end
        if i == #source.args and afterCount > 0 then
            buf[#buf+1] = (']'):rep(afterCount)
        end
        args[#args+1] = table.concat(buf)
    end
    return table.concat(args)
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

local function asDocFunction(source)
    if not source.args then
        return ''
    end
    local args = {}
    for i = 1, #source.args do
        local arg = source.args[i]
        local name = arg.name[1]
        args[i] = ('%s: %s'):format(name, vm.getInferType(arg.extends))
    end
    return table.concat(args, ', ')
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
    if source.type == 'doc.type.function' then
        return asDocFunction(source)
    end
    return ''
end
