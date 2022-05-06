local guide = require 'parser.guide'
local vm    = require 'vm'

local function asFunction(source)
    local args = {}
    local methodDef
    local parent = source.parent
    if parent and parent.type == 'setmethod' then
        methodDef = true
    end
    if methodDef then
        args[#args+1] = ('self: %s'):format(vm.getInfer(parent.node):view 'any')
    end
    if source.args then
        for i = 1, #source.args do
            local arg = source.args[i]
            if arg.type == 'self' then
                goto CONTINUE
            end
            local name = arg.name or guide.getKeyName(arg)
            if name then
                local argNode = vm.compileNode(arg)
                local optional
                if argNode:isOptional() then
                    optional = true
                    argNode = argNode:copy()
                    argNode:removeOptional()
                end
                args[#args+1] = ('%s%s: %s'):format(
                    name,
                    optional and '?' or '',
                    vm.getInfer(argNode):view('any', guide.getUri(source))
                )
            elseif arg.type == '...' then
                args[#args+1] = ('%s: %s'):format(
                    '...',
                    vm.getInfer(arg):view 'any'
                )
            else
                args[#args+1] = ('%s'):format(vm.getInfer(arg):view 'any')
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
            arg.extends and vm.getInfer(arg.extends):view 'any' or 'any'
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
