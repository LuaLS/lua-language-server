local files = require 'files'
local lang  = require 'language'
local guide = require 'parser.guide'
local vm    = require 'vm'
local await = require 'await'

local checkTypes = {
    'setlocal',
    'setglobal',
    'setfield',
    'setindex',
    'setmethod',
    'tablefield',
    'tableindex'
}

---@async
return function (uri, callback)
    if not PREVIEW then
        return
    end
    local state = files.getState(uri)
    if not state then
        return
    end

    ---@async
    guide.eachSourceTypes(state.ast, checkTypes, function (source)
        local value = source.value
        if not value then
            return
        end
        await.delay()
        if source.type == 'setlocal' then
            local locNode = vm.compileNode(source.node)
            if not locNode:getData 'hasDefined' then
                return
            end
        end
        local varNode   = vm.compileNode(source)
        local valueNode = vm.compileNode(value)
        if vm.canCastType(uri, varNode, valueNode) then
            return
        end
        callback {
            start   = source.start,
            finish  = source.finish,
            message = lang.script('DIAG_ASSIGN_TYPE_MISMATCH', {
                loc = vm.getInfer(varNode):view(uri),
                ref = vm.getInfer(valueNode):view(uri),
            }),
        }
    end)
end
