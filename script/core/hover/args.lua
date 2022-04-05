local guide = require 'parser.guide'
local infer = require 'vm.infer'

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

local function asFunction(source)
    local args = {}
    local methodDef
    local parent = source.parent
    if parent and parent.type == 'setmethod' then
        methodDef = true
    end
    if methodDef then
        args[#args+1] = ('self: %s'):format(infer.getInfer(parent.node))
    end
    if source.args then
        for i = 1, #source.args do
            local arg = source.args[i]
            if arg.dummy then
                goto CONTINUE
            end
            local name = arg.name or guide.getKeyName(arg)
            if name then
                args[#args+1] = ('%s%s: %s'):format(
                    name,
                    optionalArg(arg) and '?' or '',
                    infer.getInfer(arg):view 'any'
                )
            elseif arg.type == '...' then
                args[#args+1] = ('%s: %s'):format(
                    '...',
                    infer.getInfer(arg):view 'any'
                )
            else
                args[#args+1] = ('%s'):format(infer.getInfer(arg):view 'any')
            end
            ::CONTINUE::
        end
    end
    return args
end

local function asDocFunction(source)
    if not source.args then
        return ''
    end
    local args = {}
    for i = 1, #source.args do
        local arg = source.args[i]
        local name = arg.name[1]
        args[i] = ('%s%s: %s'):format(
            name,
            arg.optional and '?' or '',
            arg.extends and infer.getInfer(arg.extends):view 'any' or 'any'
        )
    end
    return args
end

return function (source)
    if source.type == 'function' then
        return asFunction(source)
    end
    if source.type == 'doc.type.function' then
        return asDocFunction(source)
    end
    return {}
end
