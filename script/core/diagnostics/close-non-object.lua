local files    = require 'files'
local guide    = require 'parser.guide'
local lang     = require 'language'

return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    guide.eachSourceType(state.ast, 'local', function (source)
        if not source.attrs then
            return
        end
        if source.attrs[1][1] ~= 'close' then
            return
        end
        if not source.value then
            callback {
                start   = source.start,
                finish  = source.finish,
                message = lang.script.DIAG_COSE_NON_OBJECT,
            }
            return
        end
        if source.value.type == 'nil'
        or source.value.type == 'number'
        or source.value.type == 'integer'
        or source.value.type == 'boolean'
        or source.value.type == 'table'
        or source.value.type == 'function' then
            callback {
                start   = source.value.start,
                finish  = source.value.finish,
                message = lang.script.DIAG_COSE_NON_OBJECT,
            }
            return
        end
    end)
end
