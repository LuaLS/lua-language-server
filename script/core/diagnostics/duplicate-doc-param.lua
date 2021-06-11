local files   = require 'files'
local lang    = require 'language'

return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    if not state.ast.docs then
        return
    end

    for _, doc in ipairs(state.ast.docs) do
        if doc.type ~= 'doc.param' then
            goto CONTINUE
        end
        local name = doc.param[1]
        local bindGroup = doc.bindGroup
        if not bindGroup then
            goto CONTINUE
        end
        for _, other in ipairs(bindGroup) do
            if  other ~= doc
            and other.type == 'doc.param'
            and other.param[1] == name then
                callback {
                    start   = doc.param.start,
                    finish  = doc.param.finish,
                    message = lang.script('DIAG_DUPLICATE_DOC_PARAM', name)
                }
                goto CONTINUE
            end
        end
        ::CONTINUE::
    end
end
