local files   = require 'files'
local guide   = require 'parser.guide'
local lang    = require 'language'
local vm      = require 'vm'
local await   = require 'await'

---@async
return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    if not state.ast.docs then
        return
    end

    for _, doc in ipairs(state.ast.docs) do
        if doc.type == 'doc.cast' and doc.loc then
            await.delay()
            local defs = vm.getDefs(doc.loc)
            local loc = defs[1]
            if loc then
                local defNode = vm.compileNode(loc)
                if defNode:getData 'hasDefined' then
                    for _, cast in ipairs(doc.casts) do
                        if not cast.mode and cast.extends then
                            local refNode = vm.compileNode(cast.extends)
                            if not vm.canCastType(uri, defNode, refNode) then
                                callback {
                                    start   = cast.extends.start,
                                    finish  = cast.extends.finish,
                                    message = lang.script('DIAG_CAST_TYPE_MISMATCH', {
                                        def = vm.getInfer(defNode):view(uri),
                                        ref = vm.getInfer(refNode):view(uri),
                                    })
                                }
                            end
                        end
                    end
                end
            end
        end
    end
end
