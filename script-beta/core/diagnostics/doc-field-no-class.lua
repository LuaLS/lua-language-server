local files   = require 'files'
local lang    = require 'language'

return function (uri, callback)
    local state = files.getAst(uri)
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
            elseif other == doc then
                if not ok then
                    callback {
                        start   = doc.start,
                        finish  = doc.finish,
                        message = lang.script('DIAG_DOC_FIELD_NO_CLASS'),
                    }
                end
                goto CONTINUE
            elseif other.type == 'doc.field' then
            else
                ok = false
            end
        end
        ::CONTINUE::
    end
end
