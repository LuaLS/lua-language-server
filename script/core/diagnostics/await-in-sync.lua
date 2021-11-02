local files = require 'files'
local guide = require 'parser.guide'
local vm    = require 'vm'
local lang  = require 'language'
local await = require 'await'

return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    guide.eachSourceType(state.ast, 'call', function (source) ---@async
        local currentFunc = guide.getParentFunction(source)
        if currentFunc and vm.isAsync(currentFunc, false) then
            return
        end
        await.delay()
        if not vm.isAsync(source.node, true) then
            return
        end
        callback {
            start   = source.node.start,
            finish  = source.node.finish,
            message = lang.script('DIAG_AWAIT_IN_SYNC'),
        }
    end)
end
