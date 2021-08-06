local files   = require 'files'
local lang    = require 'language'
local define  = require 'proto.define'

return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    if not state.ast.docs then
        return
    end

    for _, doc in ipairs(state.ast.docs) do
        if doc.type == 'doc.diagnostic' then
            if doc.names then
                for _, nameUnit in ipairs(doc.names) do
                    local code = nameUnit[1]
                    if not define.DiagnosticDefaultSeverity[code] then
                        callback {
                            start   = nameUnit.start,
                            finish  = nameUnit.finish,
                            message = lang.script('DIAG_UNKNOWN_DIAG_CODE', code),
                        }
                    end
                end
            end
        end
    end
end
