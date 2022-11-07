local files  = require 'files'
local guide  = require 'parser.guide'
local vm     = require 'vm'
local lang   = require 'language'
local await  = require 'await'

---@async
return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    ---@async
    guide.eachSourceType(state.ast, 'call', function (source)
        await.delay()
        local _, callArgs = vm.countList(source.args)

        local funcNode = vm.compileNode(source.node)
        local funcArgs = vm.countParamsOfNode(funcNode)

        if callArgs >= funcArgs then
            return
        end

        callback {
            start  = source.start,
            finish = source.finish,
            message = lang.script('DIAG_MISS_ARGS', funcArgs, callArgs),
        }
    end)

    ---@async
    guide.eachSourceType(state.ast, 'function', function (source)
        await.delay()
        if not source.args then
            return
        end
        local funcArgs = vm.countParamsOfSource(source)
        if funcArgs == 0 then
            return
        end
        local myArgs = #source.args
        if myArgs < funcArgs then
            callback {
                start  = source.args.start,
                finish = source.args.finish,
                message = lang.script('DIAG_MISS_ARGS', funcArgs, myArgs),
            }
        end
    end)
end
