local guide = require 'parser.guide'
local vm    = require 'vm'

local function optionalArg(arg)
    if not arg.bindDocs then
        return false
    end
    local name = arg[1]
    for _, doc in ipairs(arg.bindDocs) do
        if doc.type == 'doc.param' and doc.param[1] == name then
            return doc.optional
        end
    end
end

local function asFunction(source, oop)
    if not source.args then
        return ''
    end
    local args = {}
    for i = 1, #source.args do
        local arg = source.args[i]
        local name = arg.name or guide.getKeyName(arg)
        if name then
            args[i] = ('%s%s: %s'):format(
                name,
                optionalArg(arg) and '?' or '',
                vm.getInferType(arg)
            )
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
        if arg.extends then
            args[i] = ('%s%s: %s'):format(
                name,
                arg.optional and '?' or '',
                vm.getInferType(arg.extends)
            )
        else
            args[i] = ('%s%s'):format(
                name,
                arg.optional and '?' or ''
            )
        end
    end
    return table.concat(args, ', ')
end

return function (source, oop)
    if source.type == 'function' then
        return asFunction(source, oop)
    end
    if source.type == 'doc.type.function' then
        return asDocFunction(source)
    end
    return ''
end
