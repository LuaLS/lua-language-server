local files  = require 'files'
local guide  = require 'parser.guide'
local vm     = require 'vm'
local lang   = require 'language'

return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    guide.eachSourceType(state.ast, 'call', function (source)
        local callArgs = vm.countList(source.args)
        if callArgs == 0 then
            return
        end

        local funcNode = vm.compileNode(source.node)
        local _, funcArgs = vm.countParamsOfNode(funcNode)

        if callArgs <= funcArgs then
            return
        end
        if callArgs == 1 and source.node.type == 'getmethod' then
            return
        end
        if funcArgs + 1 > #source.args then
            local lastArg = source.args[#source.args]
            callback {
                start   = lastArg.start,
                finish  = lastArg.finish,
                message = lang.script('DIAG_OVER_MAX_ARGS', funcArgs, callArgs)
            }
        else
            for i = funcArgs + 1, #source.args do
                local arg = source.args[i]
                callback {
                    start   = arg.start,
                    finish  = arg.finish,
                    message = lang.script('DIAG_OVER_MAX_ARGS', funcArgs, callArgs)
                }
            end
        end
    end)
end
