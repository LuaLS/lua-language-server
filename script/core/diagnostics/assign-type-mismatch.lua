local files = require 'files'
local lang  = require 'language'
local guide = require 'parser.guide'
local vm    = require 'vm'
local await = require 'await'

local checkTypes = {
    'setglobal',
    'setfield',
    'setindex',
    'setmethod',
    'tablefield',
    'tableindex'
}

---@async
return function (uri, callback)
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
        local varNode   = vm.compileNode(source)
        local valueNode = vm.compileNode(value)
        if vm.getInfer(varNode):hasUnknown(uri) then
            return
        end
        if not vm.isSubType(uri, valueNode, varNode) then
            callback {
                start   = source.start,
                finish  = source.finish,
                message = lang.script('DIAG_ASSIGN_TYPE_MISMATCH', {
                    loc = vm.getInfer(varNode):view(uri),
                    ref = vm.getInfer(valueNode):view(uri),
                }),
            }
        end
    end)
end
