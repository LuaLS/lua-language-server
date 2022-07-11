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
            if not loc then
                callback {
                    start   = doc.loc.start,
                    finish  = doc.loc.finish,
                    message = lang.script('DIAG_UNKNOWN_CAST_VARIABLE', doc.loc[1])
                }
            end
        end
    end
end
