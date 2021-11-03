local files = require 'files'
local guide = require 'parser.guide'
local vm    = require 'vm'
local lang  = require 'language'
local await = require 'await'

---@async
return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    ---@async
    guide.eachSourceType(state.ast, 'call', function (source)
        local currentFunc = guide.getParentFunction(source)
        if currentFunc and vm.isAsync(currentFunc) then
            return
        end
        await.delay()
        if vm.isAsyncCall(source) then
            callback {
                start   = source.node.start,
                finish  = source.node.finish,
                message = lang.script('DIAG_AWAIT_IN_SYNC'),
            }
            return
        end
    end)
end
