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
        await.delay()
        local locNode = vm.compileNode(loc)
        if not locNode:getData 'hasDefined' then
            return
        end
        if vm.getInfer(loc):hasUnknown(uri) then
            return
        end

        -- allow `local x = {};x = nil`,
        -- but not allow `local x ---@type table;x = nil`
        local allowNil = vm.getInfer(loc):hasType(uri, 'table')
                     and not locNode:hasType 'table'

        -- allow `local x = 0;x = 1.0`,
        -- but not allow `local x ---@type integer;x = 1.0`
        local allowNumber = vm.getInfer(loc):hasType(uri, 'integer')
                        and not locNode:hasType 'integer'

        for _, ref in ipairs(loc.ref) do
            if ref.type == 'setlocal' then
                await.delay()
                local refNode = vm.compileNode(ref)
                if allowNil and vm.isSubType(uri, refNode, 'nil') then
                    goto CONTINUE
                end
                if allowNumber and vm.isSubType(uri, refNode, 'number') then
                    goto CONTINUE
                end
                if vm.isSubType(uri, refNode, locNode) then
                    goto CONTINUE
                end
                callback {
                    start   = ref.start,
                    finish  = ref.finish,
                    message = lang.script('DIAG_CAST_LOCAL_TYPE', {
                        loc = vm.getInfer(locNode):view(uri),
                        ref = vm.getInfer(refNode):view(uri),
                    }),
                }
            end
            ::CONTINUE::
        end
    end)
end
