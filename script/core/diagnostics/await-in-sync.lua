local files = require 'files'
local guide = require 'parser.guide'
local vm    = require 'vm'
local lang  = require 'language'

return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    guide.eachSourceType(state.ast, 'call', function (source)
        local currentFunc = guide.getParentFunction(source)
        if currentFunc and vm.isAsync(currentFunc) then
            return
        end
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
