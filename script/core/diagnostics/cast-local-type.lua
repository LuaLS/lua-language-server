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
        if loc[1] == '_' then
            return
        end
        await.delay()
        local locNode = vm.compileNode(loc)
        if not locNode.hasDefined then
            return
        end
        for _, ref in ipairs(loc.ref) do
            if ref.type == 'setlocal' and ref.value then
                await.delay()
                local refNode = vm.compileNode(ref)
                local value = ref.value

                if value.type == 'getfield'
                or value.type == 'getindex' then
                    -- 由于无法对字段进行类型收窄，
                    -- 因此将假值移除再进行检查
                    refNode = refNode:copy():setTruthy()
                end

                local errs = {}
                if not vm.canCastType(uri, locNode, refNode, errs) then
                    callback {
                        start   = ref.start,
                        finish  = ref.finish,
                        message = lang.script('DIAG_CAST_LOCAL_TYPE', {
                            def = vm.getInfer(locNode):view(uri),
                            ref = vm.getInfer(refNode):view(uri),
                        }) .. '\n' .. vm.viewTypeErrorMessage(uri, errs),
                    }
                end
            end
        end
    end)
end
