local files = require 'files'
local lang  = require 'language'
local guide = require 'parser.guide'
local vm    = require 'vm'
local await = require 'await'

---@async
return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    ---@async
    guide.eachSourceType(state.ast, 'local', function (loc)
        if not loc.ref then
            return
        end
        local locNode = vm.compileNode(loc)
        if not locNode:getData 'hasDefined' then
            return
        end
        for _, ref in ipairs(loc.ref) do
            if ref.type == 'setlocal' then
                await.delay()
                local refNode = vm.compileNode(ref)
                if not vm.isSubType(uri, refNode, locNode) then
                    callback {
                        start   = ref.start,
                        finish  = ref.finish,
                        message = lang.script('DIAG_CAST_LOCAL_TYPE', {
                            loc = vm.getInfer(locNode):view(uri),
                            ref = vm.getInfer(refNode):view(uri),
                        }),
                    }
                end
            end
        end
    end)
end
