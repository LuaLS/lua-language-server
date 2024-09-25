local files   = require 'files'
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
        if doc.type == 'doc.cast' and doc.name then
            await.delay()
            local defs = vm.getDefs(doc.name)
            local loc = defs[1]
            if not loc then
                callback {
                    start   = doc.name.start,
                    finish  = doc.name.finish,
                    message = lang.script('DIAG_UNKNOWN_CAST_VARIABLE', doc.name[1])
                }
            end
        end
    end
end
