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
        if doc.type == 'doc.param'
        and not doc.bindSource then
            callback {
                start   = doc.param.start,
                finish  = doc.param.finish,
                message = lang.script('DIAG_UNDEFINED_DOC_PARAM', doc.param[1])
            }
        end
    end
end
