local files = require 'files'
local guide = require 'parser.guide'
local vm    = require 'vm'
local await = require 'await'
local lang  = require 'language'

---@async
return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end
    ---@async
    guide.eachSourceType(state.ast, 'call', function (source)
        if not guide.isBlockType(source.parent) then
            return
        end
        if source.parent.filter == source then
            return
        end
        await.delay()
        if vm.isNoDiscard(source.node, true) then
            callback {
                start   = source.start,
                finish  = source.finish,
                message = lang.script('DIAG_DISCARD_RETURNS'),
            }
        end
    end)
end
