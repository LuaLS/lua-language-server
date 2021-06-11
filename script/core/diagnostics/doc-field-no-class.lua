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
        if doc.type ~= 'doc.field' then
            goto CONTINUE
        end
        local bindGroup = doc.bindGroup
        if not bindGroup then
            goto CONTINUE
        end
        local ok
        for _, other in ipairs(bindGroup) do
            if other.type == 'doc.class' then
                ok = true
                break
            end
            if other == doc then
                break
            end
        end
        if not ok then
            callback {
                start   = doc.start,
                finish  = doc.finish,
                message = lang.script('DIAG_DOC_FIELD_NO_CLASS'),
            }
        end
        ::CONTINUE::
    end
end
